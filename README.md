# aurx
The Archlinux User Repository eXplorer.

## Motivation
A simple bash script for easily managing AUR installs.

## Installation
```
git clone git@github.com:mvtab/aurx.git
cd aurx/
chmod +111 ./aurx
./aurx --help

## Soft link and completion for comfort.
#ln -sf ${PWD}/aurx ~/bin/aurx
#source <(aurx completion bash)
```

## Usage
```
aurx [OPERATION] [OPTION..] [PACKAGE..]
``` 

### Requirements

- `install`/`update`: awk, curl, echo, git, grep, jq, makepkg (pacman), sed, tee, debugedit, fakeroot, strip (binutils).
- `remove`: grep, pacman, sed.
- `search`/`completion`: curl, echo, jq.


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

#### Values
A comprehensive list of the possible configurations can be found with `aurx --help`.

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
```

##### Update all installed packages.
```bash
aurx update --all
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

##### Get bash completion for custom executable name (where `aurx` is not correct).
```bash
source <(/home/user/specific/path/aurx completion bash --executable-name /home/user/specific/path/aurx)
```

## Considerations

### Sudo password
This script intentionally does not handle sudo passwords in any way.  

### Completion
Package completions are using the AUR RPC, which has a daily rate limit of 4000 requests per IP per day.  
Every tab does one request.

## Changelog

### 2024.09.16 Breaking changes - Default source directory changed.
While adding the --persistent-path configuration option, I also refactored and changed the default work directory for more scalability.
To migrate any old data simply copy it to these locations:
```
sources:        ${HOME}/.aurx/src/
package_list:   ${HOME}/.aurx/cfg/package_list
```

Or just set the old directories with options or environment variables.

