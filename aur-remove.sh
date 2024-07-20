#!/bin/bash

aur-remove() {
	local SRC_PATH="${AUR_SRC_PATH:-${HOME}/.src}"
	local REMOVE_DEPENDENCIES=${AUR_REMOVE_DEPENDENCIES:-none}
	local ERROR_COUNT=0
	local REMOVED_COUNT=0
	local NOT_INSTALLED_COUNT=0
	local NOT_FOUND_COUNT=0
	local PACKAGE_COUNT=${#}
	
	# Sanity checks.
	if [[ ! -f ${SRC_PATH}/package_list ]]; then
		echo "[-] Package list not found. Exiting." >&2
		return 1
	fi
	if [[ -z "$(cat ${SRC_PATH}/package_list 2>/dev/null)" ]]; then
		echo "[-] Package list empty. Exiting." >&2
		return 1
	fi

	while [[ ${#} -gt 0 ]]; do
		if [[ ! $(grep -e "^${1}$" ${SRC_PATH}/package_list) ]]; then
			echo "[-] Package \"${1}\" not found in \"${SRC_PATH}/package_list\". Skipping." >&2
			((NOT_FOUND_COUNT=NOT_FOUND_COUNT+1))
			shift
			continue
		fi
		if [[ ! $(sudo pacman -Qi ${1} 2>/dev/null) ]]; then
			echo "[-] Package \"${1}\" not found on system. Skipping." >&2
			((NOT_INSTALLED_COUNT=NOT_INSTALLED_COUNT+1))
			sed -i "/^${1}$/d" ${SRC_PATH}/package_list
			echo "[+] Package \"${1}\" removed from ${SRC_PATH}/package_list."
			shift
			continue
		fi
		case ${REMOVE_DEPENDENCIES} in
			none)
				local PACMAN_UNINSTALL_ARGUMENTS='-R'
				;;
			safe)
				local PACMAN_UNINSTALL_ARGUMENTS='-Rs'
				;;
			aggressive)
				local PACMAN_UNINSTALL_ARGUMENTS='-Rcnsu'
				;;
			*)
				echo "[-] The environment variable \"AUR_REMOVE_DEPENDENCIES\" has a wrong value: \"${REMOVE_DEPENDENCIES}\"." >&2
				echo "[i] Accepted are: \"none\", \"safe\", \"aggressive\". Exiting." >&2
				return 1
				;;
		esac
		sudo pacman "${PACMAN_UNINSTALL_ARGUMENTS}" ${1}
		if [[ ${?} == 0 ]]; then
			echo "[+] Package \"${1}\" removed."
			((REMOVED_COUNT=REMOVED_COUNT+1))
			sed -i "/^${1}$/d" ${SRC_PATH}/package_list
			echo "[+] Package \"${1}\" removed from ${SRC_PATH}/package_list."
		else
			echo "[-] Could not uninstall package \"${1}\"." >&2
			((ERROR_COUNT=ERROR_COUNT+1))
		fi
		shift
	done

	if [[ ${REMOVED_COUNT} != 0 ]]; then
		echo "[+] ${REMOVED_COUNT} packages removed."
	fi
	if [[ ${ERROR_COUNT} != 0 ]]; then
		echo "[-] ${ERROR_COUNT} out of ${PACKAGE_COUNT} packages not removed." >&2
	fi
	if [[ ${NOT_FOUND_COUNT} != 0 ]]; then
		echo "[-] ${NOT_FOUND_COUNT} not found in \"${SRC_PATH}/package_list\"." >&2
	fi
	if [[ ${NOT_INSTALLED_COUNT} != 0 ]]; then
		echo "[-] ${NOT_INSTALLED_COUNT} packages were not installed on the system." >&2
	fi

	return ${ERROR_COUNT}
}

aur-remove "${@}"

