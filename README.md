# aurx
The Archlinux User Repository eXplorer.

## Installation
```
git clone git@github.com:mvtab/aurx.git
cd aurx/
chmod +111 ./aurx
./aurx --help
```

## Configuration and usage
```bash
The Archlinux User Repository eXplorer.
usage: aurx [OPERATION] [OPTION..] [PACKAGE..] 

Every option can be set through environment variables but the explicit option has the highest priority.

Operations:
  install                   Clone packages and install them with makepkg.
  remove                    Remove packages from system and the package_list.
  update                    Update packages by comparing their installed version with the latest.
  search                    Query the AUR repository with specific criterias and keywords.

Options:
  -a, --all                 Include all packages from the package_list.
  -c, --cleanup             Delete sources after successful installs.
  -C, --clean-operation     Delete sources after unsucessful installs.
  -f, --force               Forces the current process, where appliable.
  -h, --help                Display this information and exit.
  -r, --results-count       Number of results to display from search queries.
  -R, --remove-opts         Opts to give in to pacman for removing package. (Default '-R')
  -s, --source-path         Work directory for builds and persistent information.
  -S, --search-criteria     Criteria to use in search queries.
  -v, --verbosity           Level of verbosity: 0 - none, 1 - stderr, 2 - all.
  -w, --wipe-existing       Wipe eventually existing source.

Environment variables:
  AURX_ALL, AURX_CLEANUP, AURX_CLEAN_OPERATION, AURX_FORCE, AURX_RESULTS_COUNT, AURX_REMOVE_OPTS, 
  AURX_SOURCE_PATH, AURX_SEARCH_CRITERIA, AURX_VERBOSITY, AURX_WIPE_EXISTING.
```

