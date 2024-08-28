# aurx
The Archlinux User Repository eXplorer.

## Installation
```
git clone git@github.com:mvtab/aurx.git
cd aurx/
chmod +111 ./aurx

# Optional.
ln -sf ./aurx ~/bin/aurx
aurx --help

# Optional.
source <(aurx completion bash)
```

## Usage
```
aurx [OPERATION] [OPTION..] [PACKAGE..]
``` 

### Operations

operation  | description
:--------- | :----------
install    | Clone packages with git and install them with makepkg.
remove     | Remove packages from system and the package list.
update     | Convenient link to install which can be expanded.
search     | Query the AUR with specific criterias and keywords via RPC.
completion | Generate completion for the specified shell.

## Configuration

#### General
option            | description                                 | default      | env
:---------------- | :------------------------------------------ | :----------- | :--
-a, --all         | Include all installed packages.             | False        | AURX_ALL
-f, --force       | Forces the current operation, if appliable. | False        | AURX_FORCE
-h, --help        | Display usage and exit.                     | N/A          | N/A 
-s, --source-path | Work directory.                             | ${HOME}/.src | AURX_SOURCE_PATH
-v, --verbosity   | Verbosity: 0 - none, 1 - stderr, 2 - all    | 2            | AURX_VERBOSITY

#### Install, Update
option                | description                                 | default | env
:-------------------- | :------------------------------------------ | :------ | :--
-c, --cleanup         | Delete sources after successful installs.   | True    | AURX_CLEANUP
-C, --clean-operation | Delete sources after unsuccessful installs. | False   | AURX_CLEAN_OPERATION
-w, --wipe-existing   | Wipe eventually existing sources.           | False   | AURX_WIPE_EXISTING

#### Remove
option            | description                                      | default | env
:---------------- | :----------------------------------------------- | :------ | :--
-R, --remove-opts | Opts to give in to pacman for removing packages. | '-R'      | AURX_REMOVE_OPTS

#### Search
option                | description                        | default | env
:-------------------- | :--------------------------------- | :------ | :--
-r, --search-results  | Number of results to display.      | 20      | AURX_SEARCH_RESULTS
-S, --search-criteria | Criteria to use in search queries. | "name"  | AURX_SEARCH_CRITERIA

#### Completion
option                | description                | default | env
:-------------------- | :------------------------- | :------ | :--
-e, --executable-name | The name of the executable | aurx    | AURX_EXECUTABLE_NAME

## Limitations

### Non-interactive
Due to using makepkg's options to check for dependencies and install through pacman, this script can not be ran non-interactively.
Theoretically removing all parameters passed to makepkg should instantly make the script non-interactive.

### Sudo password
This script intentionally does not handle sudo passwords in any way.  

Wokarounds:  
You can increase the default duration of a sudo session by changing the `Defaults timestamp_timeout` in `/etc/sudoers`.  
Additionally or alternatively, you can refresh the sudo timeout every time you execute sudo by adding `alias sudo='sudo -v; sudo'` to your .bashrc.  

### Completion
Package completions are using the AUR RPC, which has a daily rate limit of 4000 requests per IP per day.  
Every tab does one request.

