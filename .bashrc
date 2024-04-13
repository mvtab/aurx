aur-install() {
	# Local variables.
	local SRC_PATH="${SRC_PATH:-${HOME}/.src}"

	# Sanity checks.
	[[ ! $(command -v git) ]] \
		&& echo '[-] git not found. Exiting.' >&2 \
		&& return 1
	[[ ! $(command -v makepkg) ]] \
		&& echo '[-] makepkg not found. Exiting.' >&2 \
		&& return 2

	local OLD_UMASK=$(umask)
	umask 0077
	[[ ! -d ${SRC_PATH} ]] \
		&& echo "[!] ${SRC_PATH} not found. Creating." >&2 \
		&& mkdir -p ${SRC_PATH}
	[[ ! -f ${SRC_PATH}/package_list ]] \
		&& echo "[!] ${SRC_PATH}/package_list not found. Creating." >&2 \
		&& touch ${SRC_PATH}/package_list
	[[ -d ${SRC_PATH}/${1} ]] \
		&& echo "[!] ${SRC_PATH}/${1} already exists. Deleting." >&2 \
		&& rm -rf ${SRC_PATH}/${1}
	umask ${OLD_UMASK}

	# Action.
	pushd ${SRC_PATH} 1>/dev/null
	git clone https://aur.archlinux.org/${1}.git
	if [[ -z $(ls ${SRC_PATH}/${1} 2>/dev/null) ]]; then
		local EXIT_STATUS=3
	else
		local EXIT_STATUS=0
	fi
	popd 1>/dev/null
	if [[ ${EXIT_STATUS} == 0 ]]; then
		pushd ${SRC_PATH}/${1} 1>/dev/null
		makepkg -sirc
		local EXIT_STATUS=${?}
		popd 1>/dev/null
	else
		echo "[-] Pulled an empty repository: ${1}. Exiting." >&2
		rm -rf ${SRC_PATH}/${1}
		return ${EXIT_STATUS}
	fi
	if [[ ${EXIT_STATUS} == 0 ]]; then
		if [[ ! $(grep -e "${1}" ${SRC_PATH}/package_list) ]]; then
			echo ${1} | tee -a ${SRC_PATH}/package_list 1>/dev/null
		fi
		rm -rf ${SRC_PATH}/${1}
		return 0
	else
		echo "[-] Could not install ${1}. Exiting." >&2
		rm -rf ${SRC_PATH}/${1}
		return 5
	fi
}

aur-update() {
	local SRC_PATH="${SRC_PATH:-${HOME}/.src}"
	
	# Sanity checks.
	[[ ! -f ${SRC_PATH}/package_list ]] \
		|| [[ -z "$(cat ${SRC_PATH}/package_list)" ]] \
		&& echo "[-] Package list empty or not found. Exiting." >&2 \
		&& return 1
	[[ ! $(command -v aur-install) ]] \
		&& echo "[-] Dependent function not found: aur-install. Exiting." >&2 \
		&& return 2
	for ITEM in $(cat ${SRC_PATH}/package_list); do
		aur-install ${ITEM} || echo "[-] Could not install ${ITEM}. Skipping."
	done
}

