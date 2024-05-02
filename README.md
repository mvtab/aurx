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
 
 - aur-remove:
> **AUR_REMOVE_DEPENDENCIES**  
  Remove also dependencies of selected packages.  
  Options are:  
  none -> 	pacman -R  
  low -> pacman -Rsu  
  medium -> pacman -Rsunc  
  full -> pacman -Rsnc  

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
aur-remove [PACKAGE..]
aur-update
```
