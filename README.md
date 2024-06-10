# aur-functions
.bashrc functions for Archlinux User Repository (AUR) packages.

## Installation
```bash
source aur_functions
# or 
cat aur_functions >> .bashrc
# or any other way to use a function in bash.
```
## Configuration
The functions read the following environment variables:
- General:

>  **AUR_SRC_PATH**  
  Work directory of the function.  
  Will store ${SRC_PATH}/package_list persistently.  
  Default: "${HOME}/.src"
  
- aur-install:
 > **AUR_FORCE_REINSTALL**  
   Install packages even if they are already installed and up to date.  
  Default: "no"
  
> **AUR_CLEAN_SOURCE**  
  Delete source directory if it already exists before installation.  
  Default: "no"

> **AUR_DELETE_SOURCE_ON_SUCCESS**  
  Delete source if installation succeeds.  
  Default: "yes"
 
> **AUR_DELETE_SOURCE_ON_FAIL**  
  Delete source if installation fails.  
  Default: "no"

- aur-search:  
> **AUR_SEARCH_BY**  
  The search criteria. More info [here](https://wiki.archlinux.org/title/Aurweb_RPC_interface).  
  Default: "name"  
  Options are:  
  name -> search by package name only  
  name-desc -> search by package name and description  
  maintainer -> search by package maintainer  
  depends -> search for packages that depend on keywords  
  makedepends -> search for packages that makedepend on keywords  
  optdepends -> search for packages that optdepend on keywords  
  checkdepends -> search for packages that checkdepend on keywords  
  starts_with -> return a list of packages that start with the selected pattern  

> **AUR_MAX_SEARCH_RESULTS**  
  How many results to return.  
  Default: 20  
 
- aur-remove:
> **AUR_REMOVE_DEPENDENCIES**  
  Remove also dependencies of selected packages.  
  Default: "none"
  Options are:  
  none -> 	pacman -R  
  low -> pacman -Rs  
  medium -> pacman -Rcnsu  
  full -> pacman -Rcns  

## Usage
Set any environment variables either by exporting them:
```bash
export VARIABLE=VALUE
```
or inline at execution:
```bash
[VARIABLE=VALUE].. aur-install [PACKAGE]..
AUR_SRC_PATH="/tmp" AUR_FORCE_REINSTALL="yes" aur-install test
```

and minimally manage aur packages:
```bash
aur-install [PACKAGE..]
aur-search KEYWORD
aur-remove [PACKAGE..]
aur-update
```
