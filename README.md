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
install    | pretty safe option for installing custom sources.
remove     | Remove packages from system and the package list.
update     | pretty safe option for installing default sources. (will overwrite and delete existent ones)
search     | query the AUR with specific criterias and keywords via RPC.
completion | generate completion for the specified shell.

## Configuration

#### Environment variables
Capitalized long option names with AURX_ prefix, for example: AURX_SEARCH_CRITERIA.

#### General
option            | description                                 | default      
:---------------- | :------------------------------------------ | :------ 
-a, --all         | Include all installed packages.             | false 
-f, --force       | Forces the current operation, if appliable. | false 
-h, --help        | Display usage and exit.                     | N/A 
-s, --source-path | Work directory.                             | ${HOME}/.src 
-v, --verbosity   | Verbosity: 0 - none, 1 - stderr, 2 - all    | 2 

#### Install
option                    | description                                 | default
:------------------------ | :------------------------------------------ | :------
-c, --cleanup             | Delete sources after successful installs.   | false
-C, --clean-operation     | Delete sources after unsuccessful installs. | false
-M, --makepkg-args        | Args to give in to makepkg installs.        | '-sirc'
-p, --only-pull           | Only pulls the repository from AUR          | false
-V, --verify-versions     | compare target versions to installed ones.  | false
-w, --wipe-existing       | Wipe eventually existing sources.           | false
-W, --overwrite-existing  | can the existing sources be overwritten     | false
-x, --comparison-criteria | criteria to use when comparing packages     | "rpc" 

#### Remove
option            | description                                      | default 
:---------------- | :----------------------------------------------- | :------
-R, --remove-opts | Opts to give in to pacman for removing packages. | '-R' 

#### Search
option                | description                        | default 
:-------------------- | :--------------------------------- | :------
-r, --search-results  | Number of results to display.      | 20
-S, --search-criteria | Criteria to use in search queries. | "name"
-b, --sort-by         | Key to sort results by.            | "popularity"
-o, --order-by        | How to order search results.       | "descending"
-O, --no-out-of-date  | Remove all out of date packages.   | false
-m, --maintained      | Only return maintained packages.   | false

#### Update
option                    | description                        | default 
:------------------------ | :--------------------------------- | :------
-B, --block-overwrite     | Don't allow overwriting existing sources. | false
-k, --keep-sources        | Don't cleanup after successful installs   | false
-K, --keep-failed-sources | Don't cleanup after unsuccessful installs | false
-M, --makepkg-args        | Args to give in to makepkg installs.      | '-sirc'
-x, --comparison-criteria | criteria to use when comparing packages   | "rpc" 

#### Completion
option                | description                | default 
:-------------------- | :------------------------- | :------ 
-e, --executable-name | The name of the executable | \${0}

## Limitations

### Pretty safe
Do notice the "pretty safe" in install and update's descriptions, which should be a warning.  
Don't use this script's base dir as sole copy of your work.

### Non-interactive
Due to using makepkg's options to check for dependencies and install through pacman, this script can not be run non-interactively.
Theoretically removing all parameters passed to makepkg should instantly make the script non-interactive.

### Sudo password
This script intentionally does not handle sudo passwords in any way.  

Wokarounds:  
You can increase the default duration of a sudo session by changing the `Defaults timestamp_timeout` in `/etc/sudoers`.  
Additionally or alternatively, you can refresh the sudo timeout every time you execute sudo by adding `alias sudo='sudo -v; sudo'` to your .bashrc.  

### Completion
Package completions are using the AUR RPC, which has a daily rate limit of 4000 requests per IP per day.  
Every tab does one request.

