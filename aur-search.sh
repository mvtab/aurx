#!/bin/bash

aur-search() {
	local SEARCH_BY="${AUR_SEARCH_BY:-name}"
	local MAX_SEARCH_RESULTS="${AUR_MAX_SEARCH_RESULTS:-20}"
	local SEARCH_PATTERN="${1}"
	local SEARCH_PATTERN=${SEARCH_PATTERN//[^a-zA-Z0-9_-]/}

	if [[ "${#1}" -le 1 ]]; then
		echo "[-] Query pattern must be at least 2 characters long. Your pattern is: \"${SEARCH_PATTERN}\"." >&2
		return 1
	fi		

	case "${SEARCH_BY}" in
		name | name-desc | maintainer | depends | makedepends | optdepends | checkdepends)
			local RESULTS=$(curl https://aur.archlinux.org/rpc/v5/search/${SEARCH_PATTERN}?by=${SEARCH_BY} 2>/dev/null \
				| jq -r ".results[:${MAX_SEARCH_RESULTS}]" | jq -r '.[] | "\(.Maintainer)/\(.Name) \(.Version) \n\t\(.Description)"')
			;;
		starts_with)
			local RESULTS=$(curl https://aur.archlinux.org/rpc/v5/suggest/${SEARCH_PATTERN} 2>/dev/null | jq -r ".[:${MAX_SEARCH_RESULTS}]")
			;;
		*)
			echo "[-] The environment variable \"AUR_SEARCH_BY\" has a wrong value: \"${SEARCH_BY}\"." >&2
			echo "[i] Accepted are: \"name\", \"name-desc\", \"maintainer\", \"depends\", \"makedepends\", \"optdepends\", \"checkdepends\", \"starts_with\". Exiting." >&2
			return 1
			;;
	esac
		
	
	if [[ ! -z ${RESULTS} ]]; then
		echo "${RESULTS}"
		return 0
	else
		echo "[-] No package matched the criteria." >&2
		return 1
	fi
}

aur-search "${@}"

