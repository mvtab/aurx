# aur-functions
.bashrc functions for Archlinux User Repository (AUR) packages.

## Usage
```bash
source aur_functions

# (Optional) export AUR_SRC_PATH=./somedir
# default: ${HOME}/.src

aur-install [PACKAGE..]

# (Optional) export AUR_REMOVE_DEPENDENCIES=low
# values: none (default), low, medium, full
aur-remove [PACKAGE..]

aur-update
```
## Motivation
Practical, lightweight way of managing and tracking AUR source codes.
Development use only. 

