# aurx
The Archlinux User Repository eXplorer.

## Motivation
This script strides to be a lightweight AUR helper that takes on AUR-related tasks and nothing more.  
It also offers the freedom to manipulate and keep track of all kinds of sources: self maintained or online ones. Theoretically it could be expanded to offer upload functionality to AUR.  

## Installation
```
git clone git@github.com:mvtab/aurx.git
cd aurx/
chmod +111 ./aurx

# Optional.

## Soft link.
ln -sf ${PWD}/aurx ~/bin/aurx

## Completion.
source <(aurx completion bash --executable-name aurx)
```

## Usage
```
aurx [OPERATION] [OPTION..] [PACKAGE..]
``` 

### Operations

operation  | description
:--------- | :----------
install    | designated option for comfortably managing custom sources.
remove     | Remove packages from system and the package list.
update     | designated option for installing online packages using `/tmp` as workdir.
search     | query the AUR with specific criterias and keywords via RPC.
completion | generate completion for the specified shell.

## Configuration

#### Environment variables
Capitalized long option names with `AURX_` prefix. For example for `--search-criteria`: `AURX_SEARCH_CRITERIA`.

#### General
option                | description                                 | default           | values 
:-------------------- | :------------------------------------------ | :---------------- | :-----
-a, --all             | Include all installed packages.             | false             | true, false
-f, --force           | Forces the current operation, if appliable. | false             | true, false
-h, --help            | Display usage and exit.                     | N/A               | N/A
-p, --persistent-path | Where to save persistent information.       | ${HOME}/.aurx/cfg | any path
-s, --source-path     | Work directory.                             | ${HOME}/.aurx/src | any path
-v, --verbosity       | Verbosity: 0 - none, 1 - stderr, 2 - all    | 2                 | 0, 1, 2

#### Install
option                    | description                                 | default | values
:------------------------ | :------------------------------------------ | :------ | :-----
-c, --cleanup             | Delete sources after successful installs.   | false   | true, false
-C, --clean-operation     | Delete sources after unsuccessful installs. | false   | true, false
-M, --makepkg-opts        | Opts to give in to makepkg installs.        | '-sirc' | any makepkg opts
-d, --download-only       | Only downloads the repository from AUR.     | false   | true, false
-V, --verify-versions     | compare target versions to installed ones.  | false   | true, false
-w, --wipe-existing       | Wipe eventually existing sources.           | false   | true, false
-W, --overwrite-existing  | can the existing sources be overwritten     | false   | true, false
-x, --comparison-criteria | criteria to use when comparing packages     | "rpc"   | "rpc", "pkgbuild"

#### Remove
option            | description                                      | default | values
:---------------- | :----------------------------------------------- | :------ | :-----
-R, --remove-opts | Opts to give in to pacman for removing packages. | '-R'    | any pacman opts

#### Update
option                    | description                               | default | values
:------------------------ | :---------------------------------------- | :------ | :-----
-B, --block-overwrite     | Don't allow overwriting existing sources. | false   | true, false
-k, --keep-sources        | Don't cleanup after successful installs   | false   | true, false
-K, --keep-failed-sources | Don't cleanup after unsuccessful installs | false   | true, false
-M, --makepkg-opts        | Opts to give in to makepkg installs.      | '-sirc' | any makepkg opts
-x, --comparison-criteria | criteria to use when comparing packages   | "rpc"   | "rpc", "pkgbuild"

#### Search
option                | description                        | default      | values
:-------------------- | :--------------------------------- | :----------- | :-----
-r, --search-results  | Number of results to display.      | 20           | any int
-S, --search-criteria | Criteria to use in search queries. | "name"       | "name", "name-desc", "maintainer", "depends", "makedepends", "optdepends", "checkdepends", "suggest"
-b, --sort-by         | Key to sort results by.            | "popularity" | "firstsubmitted", "lastmodified", "votes", "popularity"
-o, --order-by        | How to order search results.       | "descending" | "ascending", "descending"
-O, --no-out-of-date  | Remove all out of date packages.   | false        | true, false
-m, --maintained      | Only return maintained packages.   | false        | true, false

#### Completion
option                | description                | default | values
:-------------------- | :------------------------- | :------ | :-----
-e, --executable-name | The name of the executable | \${0}   | any string

#### Running in containers
There is a folder called `containers` that contains detailed instructions for running aurx in a container environment.

#### Non-interactive
Script can be ran noninteractively by changing the makepkg opts (`-M`, `--makepkg-opts`) to, for example, `'--noconfirm -sirc'`.  
`sudo` password must be handled by the user. (see Limitations)

## Examples

##### Install a new package or an existing source.
```bash
aurx install test
```

##### Remove a package from the system and the script's package list, with custom pacman remove flags.
```bash
aurx remove test --remove-opts '-Rsncu'
```

##### Download a package to modify before install.
```bash
aurx install test --download-only --source-path /tmp
cd /tmp/test
# modifications
cd -
aurx install test --source-path /tmp
```

##### Update a package only if the present source's version is higher than the installed one.
```bash
aurx install test --verify-versions --comparison-criteria pkgbuild
```

##### Update a package to the latest version available online and delete source after.
```bash
aurx update test
# equivalent of
aurx install test --verify-versions --overwrite-existing --cleanup --clean-operation --source-path /tmp --persistent-path ${HOME}/.aurx/cfg
```

##### Update all installed packages.
```bash
aurx update --all
# equivalent of 
aurx install --all --verify-versions --overwrite-existing --cleanup --clean-operation --source-path /tmp --persistent-path ${HOME}/.aurx/cfg
```

##### Query the AUR looking for only up to date and maintainted packages, sorting results by votes.
```bash
aurx search test --no-out-of-date --maintained --sort-by votes
```

##### Grab the all-time first 5 submitted packages of a maintainer.
```bash
aurx search FabioLolix --search-criteria maintainer --sort-by firstsubmitted --order-by ascending --search-results 5
```

##### Grab the latest 5 modified packages that have gcc as makedepends.
```bash
aurx search gcc --search-criteria makedepends --sort-by lastmodified --search-results 5
```

##### Get bash completion for custom executable name (where ${0} is not correct).
```bash
source <(aurx completion bash --executable-name aurx)
```

## Limitations

### Not intensively tested
Don't use this script's base dir as sole copy of your work.

### Sudo password
This script intentionally does not handle sudo passwords in any way.  

Wokarounds:  
You can increase the default duration of a sudo session by changing the `Defaults timestamp_timeout` in `/etc/sudoers`.  
Additionally or alternatively, you can refresh the sudo timeout every time you execute sudo by adding `alias sudo='sudo -v; sudo'` to your .bashrc.  

### Completion
Package completions are using the AUR RPC, which has a daily rate limit of 4000 requests per IP per day.  
Every tab does one request.

## Changelog


### 09.16.2024 Breaking changes - Default source directory changed.
While adding the --persistent-path configuration option, I also refactored and changed the default work directory for more scalability.
To migrate any old data simply copy it to these locations:
```
sources:        ${HOME}/.aurx/src/
package_list:   ${HOME}/.aurx/cfg/package_list
```

Or just set the old directories with options or environment variables.

