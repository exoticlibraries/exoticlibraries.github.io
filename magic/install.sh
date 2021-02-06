#!/bin/bash

# This script downloads exotic libraries for Unix, Linux and Mac based systems.
# Any header only library hosted on github with the include folder in the main tree
# can be installed using this script. Alternatively the absolute path to the header file 
# on the internet can be specified, it will be downloaded and installed.
#
# The libraries is into one of the following system library path
#  - /usr/local/include/
#  - /usr/include/
# 
# Sample Usage:
# To install libxtd
#     bash <(curl -s https://exoticlibraries.github.io/magic/install.sh) libxtd
# 
# To install libcester
#     bash <(curl -s https://exoticlibraries.github.io/magic/install.sh) libcester
# 
# To install libxtd and libcester
#     bash <(curl -s https://exoticlibraries.github.io/magic/install.sh) libxtd libcester
# 
# License: MIT
# Author: Adewale Azeez <azeezadewale98@gmail.com>

SELECTED_LIBRARIES=()
EXOTIC_LIBRARIES=(
    libxtd
    libcester
    libmetaref
)
IS_ROOT=true
REPO_BRANCH=main
ARG_MATCH=false
EXTRACTED_ARG_VALUE=
OVERRIDE_EXISTING=false
INSTALLATION_PATH=/usr/local/include

main() {
    check_if_is_root
    if [ "$IS_ROOT" == "true" ]; then
        INSTALLATION_PATH=/usr/include
    fi
    for ARG in "$@"
    do
        match_and_extract_argument $ARG
        if [[ " ${EXOTIC_LIBRARIES[@]} " =~ " ${ARG_MATCH} " ]]; then
            poof_out_github_link_for_library $ARG_MATCH
            SELECTED_LIBRARIES="$SELECTED_LIBRARIES $ARG_MATCH"

        elif [[ "--override" == "$ARG_MATCH" ]]; then
            OVERRIDE_EXISTING=true

        elif [[ "--installfolder" == "$ARG_MATCH" ]]; then
            INSTALLATION_PATH=$EXTRACTED_ARG_VALUE

        elif [[ "--branch" == "$ARG_MATCH" ]]; then
            REPO_BRANCH=$EXTRACTED_ARG_VALUE

        else
            poof_out_github_link_for_library $ARG_MATCH
            SELECTED_LIBRARIES="$SELECTED_LIBRARIES $ARG_MATCH"

        fi
    done
    for element in ${SELECTED_LIBRARIES[@]}; do
        echo "Install -> $element"
    done
    echo "Override existing: $OVERRIDE_EXISTING"
    echo $INSTALLATION_PATH
    echo "Clone repo from branch '$REPO_BRANCH'"
}

match_and_extract_argument() {
    ARG=$1
    ARG_MATCH=${ARG%=*}
    EXTRACTED_ARG_VALUE=${ARG#*=}
}

poof_out_github_link_for_library() {
    LIBRARY=$1
    if [[ " ${LIBRARY[@]} " =~ "github.com" ]]; then
        ARG_MATCH=$LIBRARY
        
    elif [[ " ${LIBRARY[@]} " =~ "/" ]]; then
        ARG_MATCH="https://github.com/$LIBRARY.git"
        
    else
        ARG_MATCH="https://github.com/exoticlibraries/$LIBRARY.git"
    fi
}

check_if_is_root() {
    if [ "$EUID" -ne 0 ]; then 
        IS_ROOT=false
    fi
}

main $@
exit 0