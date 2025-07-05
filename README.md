# aurx
The Archlinux User Repository eXplorer.

## Motivation
A simple bash script for easily managing AUR installs.

## Installation
```
git clone git@github.com:mvtab/aurx.git
#git clone https://github.com/mvtab/aurx
cd aurx/
chmod +111 ./aurx
./aurx --help

## Soft link and completion for comfort.
#ln -sf ${PWD}/aurx ~/bin/aurx
#source <(aurx completion bash)
```

## Usage
```
aurx [OPERATION] [OPTION].. [PACKAGE]..
``` 

### Requirements

##### install / update
> curl, echo, git, grep, jq, pacman, sed, tee.

##### remove
> grep, pacman, sed.

##### search
> curl, echo, jq.  
> optional: pacman (for package installation status).

##### completion / list
> curl, echo, jq.

### Operations

operation  | description
:--------- | :----------
install    | install any package from AUR or the working directory.
remove     | Remove packages from system and the package list.
update     | force install any package from AUR and delete source after.
search     | query the AUR database via the HTTP RPC API.
completion | generate completion for the specified shell.
list       | search for all locally installed AUR packages.

## Configuration

#### Environment variables
Capitalized long option names with `AURX_` prefix. For example for `--search-criteria`: `AURX_SEARCH_CRITERIA`.

#### Values
A comprehensive list of the possible configurations can be found with `aurx --help` or by using the bash completion.

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
aurx search SomeMaintainerName --search-criteria maintainer --sort-by firstsubmitted --order-by ascending --search-results 5
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
Package completions are using the AUR HTTP RPC API, which has a daily rate limit of 4000 requests per IP per day.  

### Search installed mark
Packages may be falsely marked as installed in search operations, if coincidentally an installed package is called exactly like one found online.  
The `[installed]` mark does **not** mean the package is up to date.

### List
If the results include not installed packages or search errors, it means an installed package is not on AUR anymore and you probably want to check that out. 

## Changelog

### 2024.09.16 Breaking changes - Default source directory changed.
While adding the --persistent-path configuration option, I also refactored and changed the default work directory for more scalability.
To migrate any old data simply copy it to these locations:
```
package_list:   ${HOME}/.aurx/cfg/package_list
sources:        ${HOME}/.aurx/src/
```

Or just set the old directories with options or environment variables.

