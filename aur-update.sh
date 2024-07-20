#!/bin/bash

aur-update() {
	local SRC_PATH="${AUR_SRC_PATH:-${HOME}/.src}"
	local PACKAGE_COUNT=$(cat ${SRC_PATH}/package_list 2>/dev/null | wc -l)
	local UP_TO_DATE_COUNT=0
	local UPDATED_COUNT=0
	local ERROR_COUNT=0
	local REQUIRED_PACKAGES=('curl' 'jq' 'pacman' 'aur-install')
	
	# Sanity checks.
	if [[ ! -f ${SRC_PATH}/package_list ]]; then
		echo "[-] Package list not found. Exiting." >&2
		return 1
	fi
	if [[ -z "$(cat ${SRC_PATH}/package_list 2>/dev/null)" ]]; then
		echo "[-] Package list empty. Exiting." >&2
		return 1
	fi
	for PACKAGE in "${REQUIRED_PACKAGES[@]}"; do
		if [[ ! $(command -v ${PACKAGE}) ]]; then
			echo "[-] \"${PACKAGE}\" not found. Exiting." >&2
			return 1
		fi
	done
	
	# Execution.
	for PACKAGE in $(cat ${SRC_PATH}/package_list); do
		local LATEST_VERSION=$(curl https://aur.archlinux.org/rpc/v5/info?arg[]=${PACKAGE} 2>/dev/null \
			| jq .results.[0].Version | tr -d '"')
		local INSTALLED_VERSION=$(sudo pacman -Qi ${PACKAGE} 2>/dev/null \
			| grep -e "Version" | awk '{ print $3 }')
		if [[ ${LATEST_VERSION} == ${INSTALLED_VERSION} ]]; then 
			echo "[i] \"${PACKAGE}\" is up to date."
			((UP_TO_DATE_COUNT=UP_TO_DATE_COUNT+1))
			shift
			continue
		fi
		read -p "[>>] A new version for \"${PACKAGE}\" is available. Install? [Y/n] " INSTALL_FOUND_PACKAGE
		case ${INSTALL_FOUND_PACKAGE:0:1} in
			Y|y|'' )
				aur-install ${PACKAGE}
				if [[ ${?} == 0 ]]; then
					echo "[+] \"${PACKAGE}\" updated."
					((UPDATED_COUNT=UPDATED_COUNT+1))
				else
					echo "[-] Could not update \"${PACKAGE}\". Skipping." >&2
					((ERROR_COUNT=ERROR_COUNT+1))
				fi
				;;
			* )
				continue
				;;
		esac
	done

	if [[ ${ERROR_COUNT} != 0 ]]; then
		echo "[-] Could not update ${ERROR_COUNT} out of ${PACKAGE_COUNT} packages." >&2
	fi
	if [[ ${UPDATED_COUNT} != 0 ]]; then
		echo "[+] ${UPDATED_COUNT} packages updated."
	fi
	if [[ ${UP_TO_DATE_COUNT} != 0 ]]; then
		echo "[+] ${UP_TO_DATE_COUNT} packages already up to date."
	fi

	return ${ERROR_COUNT}
}

aur-update "${@}"

