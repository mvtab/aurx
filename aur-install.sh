#!/bin/bash

aur-install() {
	local SRC_PATH="${AUR_SRC_PATH:-${HOME}/.src}"
	local FORCE_REINSTALL="${AUR_FORCE_REINSTALL:-no}"
	local CLEAN_SOURCE="${AUR_CLEAN_SOURCE:-no}"
	local DELETE_SOURCE_ON_SUCCESS="${AUR_DELETE_SOURCE_ON_SUCCESS:-yes}"
	local DELETE_SOURCE_ON_FAIL="${AUR_DELETE_SOURCE_ON_FAIL:-no}"
	local OLD_UMASK=$(umask)
	local PACKAGE_COUNT=${#}
	local ALREADY_INSTALLED_COUNT=0
	local NOT_FOUND_COUNT=0
	local INSTALLED_COUNT=0
	local ERROR_COUNT=0
	local REQUIRED_PACKAGES=('curl' 'jq' 'git' 'makepkg' 'pacman')

	umask 0077

	# Sanity checks.
	for REQUIRED_PACKAGE in "${REQUIRED_PACKAGES[@]}"; do
		if [[ ! $(command -v ${REQUIRED_PACKAGE}) ]]; then
			echo "[-] \"${REQUIRED_PACKAGE}\" not found. Exiting." >&2
			return 1
		fi
	done
	if [[ ! -d "${SRC_PATH}" ]]; then
		echo "[!] \"${SRC_PATH}\" not found. Creating." >&2
		mkdir -p ${SRC_PATH}
	fi
	if [[ ! -f "${SRC_PATH}/package_list" ]]; then
		echo "[!] \"${SRC_PATH}/package_list\" not found. Creating." >&2
		touch "${SRC_PATH}/package_list"
	fi

	# Execution.
	while [[ ${#} -gt 0 ]]; do
		# Conflict checks.
		local LATEST_VERSION=$(curl https://aur.archlinux.org/rpc/v5/info?arg[]=${1} 2>/dev/null \
			| jq .results.[0].Version | tr -d '"')
		local INSTALLED_VERSION=$(sudo pacman -Qi ${1} 2>/dev/null \
			| grep -e "Version" | awk '{ print $3 }')
		if [[ "${FORCE_REINSTALL}" != "yes" ]] && [[ ${LATEST_VERSION} == ${INSTALLED_VERSION} ]]; then
			echo "[+] Package \"${1}\" already installed. Skipping."
			((ALREADY_INSTALLED_COUNT=ALREADY_INSTALLED_COUNT+1))
			if [[ ! $(grep -e "${1}" ${SRC_PATH}/package_list) ]]; then
				echo ${1} | tee -a ${SRC_PATH}/package_list 1>/dev/null
			fi
			shift
			continue
		elif [[ -z ${INSTALLED_VERSION} ]]; then
			echo "[i] Installing package \"${1}\"."
		elif [[ ${LATEST_VERSION} != ${INSTALLED_VERSION} ]]; then
			echo "[i] Package \"${1}\" is installed but a new version is available. Installing." 
		fi
		if [[ "${CLEAN_SOURCE}" == "yes" ]] && [[ -d ${SRC_PATH}/${1} ]]; then
			echo "[!] \"${SRC_PATH}/${1}\" already exists. Deleting." >&2
			rm -rf ${SRC_PATH}/${1}
		fi

		pushd ${SRC_PATH} 1>/dev/null
		git clone https://aur.archlinux.org/${1}.git
		[[ -z $(ls ${SRC_PATH}/${1} 2>/dev/null) ]] \
			&& local GIT_EXIT_STATUS=1 \
			|| local GIT_EXIT_STATUS=0
		popd 1>/dev/null
		if [[ ${GIT_EXIT_STATUS} == 0 ]]; then
			pushd ${SRC_PATH}/${1} 1>/dev/null
			makepkg -sirc
			local MAKEPKG_EXIT_STATUS=${?}
			popd 1>/dev/null
		else
			echo "[-] Package \"${1}\" not found in the AUR. Skipping." >&2
			local MAKEPKG_EXIT_STATUS=1
			((NOT_FOUND_COUNT=NOT_FOUND_COUNT+1))
			rm -rf ${SRC_PATH}/${1}
		fi
		if [[ ${MAKEPKG_EXIT_STATUS} == 0 ]]; then
			if [[ ! $(grep -e "${1}" ${SRC_PATH}/package_list) ]]; then
				echo ${1} | tee -a ${SRC_PATH}/package_list 1>/dev/null
			fi
			((INSTALLED_COUNT=INSTALLED_COUNT+1))
			if [[ "${DELETE_SOURCE_ON_SUCCESS}" == "yes" ]]; then
				rm -rf ${SRC_PATH}/${1}
			fi
		else
			echo "[-] Could not install \"${1}\". Skipping." >&2
			if [[ "${DELETE_SOURCE_ON_FAIL}" == "yes" ]]; then
				rm -rf ${SRC_PATH}/${1}
			fi
			((ERROR_COUNT=ERROR_COUNT+1))
		fi
		shift
	done

	if [[ ${INSTALLED_COUNT} != 0 ]]; then
		echo "[+] ${INSTALLED_COUNT} new packages installed."
	fi
	if [[ ${ALREADY_INSTALLED_COUNT} != 0 ]]; then
		echo "[+] ${ALREADY_INSTALLED_COUNT} packages were already installed and up to date."
	fi
	if [[ ${ERROR_COUNT} != 0 ]]; then
		echo "[-] ${ERROR_COUNT} out of ${PACKAGE_COUNT} packages could not be installed." >&2
	fi
	if [[ ${NOT_FOUND_COUNT} != 0 ]]; then
		echo "[-] ${NOT_FOUND_COUNT} could not be found in the Archlinux User Repository." >&2
	fi

	umask ${OLD_UMASK}

	return ${ERROR_COUNT}
}

aur-install "${@}"

