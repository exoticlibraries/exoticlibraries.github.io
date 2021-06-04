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
# To view help
#     bash <(curl -s https://exoticlibraries.github.io/magic/install.sh) -h
#     bash <(curl -s https://exoticlibraries.github.io/magic/install.sh) --help
#
# To install libxtd
#     bash <(curl -s https://exoticlibraries.github.io/magic/install.sh) libxtd
# 
# To install libcester
#     bash <(curl -s https://exoticlibraries.github.io/magic/install.sh) libcester
# 
# To install libxtd and libcester
#     bash <(curl -s https://exoticlibraries.github.io/magic/install.sh) libxtd libcester
# 
# To install gunslinger from github from master branch
#     bash <(curl -s https://exoticlibraries.github.io/magic/install.sh) MrFrenik/gunslinger@master
# 
# To install stb from github from master branch
#     bash <(curl -s https://exoticlibraries.github.io/magic/install.sh) https://github.com/nothings/stb@master
# 
# License: MIT
# Author: Adewale Azeez <azeezadewale98@gmail.com>

VERSION=v2.0
LICENSE=MIT
YEAR=2021
AUTHOR="Adewale Azeez"
BASE_BRANCH=main
SELECTED_LIBRARIES=()
EXOTIC_LIBRARIES=(
    libxtd
    libcester
    libmetaref
    libcline
    libfio
)
IS_ROOT=true
ARG_MATCH=false
EXTRACTED_ARG_VALUE=
INSTALLATION_PATH=/usr/local/include
TMP_FOLDER=/tmp/
CLEANUP=true

echo "Exotic Libraries Magic Install Script $VERSION"
echo "The $LICENSE License Copyright (c) $YEAR $AUTHOR"

main() {
    check_if_is_root
    if [ "$IS_ROOT" == "true" ]; then
        INSTALLATION_PATH=/usr/include
    fi
    for ARG in "$@"
    do
        match_and_extract_argument $ARG
        if [[ "-h" == "$ARG_MATCH" || "--help" == "$ARG_MATCH" ]]; then
            print_help

        elif [[ "--dontclean" == "$ARG_MATCH" ]]; then
            CLEANUP=false

        elif [[ "--installfolder" == "$ARG_MATCH" ]]; then
            INSTALLATION_PATH=$EXTRACTED_ARG_VALUE

        elif [[ "--tmpfolder" == "$ARG_MATCH" ]]; then
            TMP_FOLDER=$EXTRACTED_ARG_VALUE

        elif [[ "--basebranch" == "$ARG_MATCH" ]]; then
            BASE_BRANCH=$EXTRACTED_ARG_VALUE

        elif [[ "--all" == "$ARG_MATCH" ]]; then
            for LIBRARY in ${EXOTIC_LIBRARIES[@]}; do
                SELECTED_LIBRARIES+=($LIBRARY)
            done

        else
            if [[ " ${ARG_MATCH[@]} " =~ "--" ]]; then 
                fail_with_message "Unknow option '$ARG_MATCH'"
            fi
            if [[ ! " ${SELECTED_LIBRARIES[@]} " =~ " ${ARG_MATCH} " ]]; then
                SELECTED_LIBRARIES+=($ARG_MATCH)
            fi

        fi
    done
    validate_paths
    install_libraries
    cleanup_residuals
}

match_and_extract_argument() {
    ARG=$1
    ARG_MATCH=${ARG%=*}
    EXTRACTED_ARG_VALUE=${ARG#*=}
}

print_help() {
    echo "Usage: ./install.sh [OPTIONS] [LIBRARIES...]"
    echo ""
    echo "[LIBRARIES..]: The headers only libraries to install e.g. libcester@dev nothings/stb@master"
    echo "[OPTIONS]    : The script options"
    echo ""
    echo "The OPTIONS include:"
    echo "-h --help          Display this help message and exit"
    echo "--all              Install all exotic libraries"
    echo "--dontclean        Skip cleanup , leave the downloaded and extracted archive in the temp folder"
    echo "--installfolder=[FOLDER] Specify the folder to install the library into, default is /usr/local/include"
    echo "--tmpfolder=[FOLDER]      Specify the folder to download archive and tmp files, default is /tmp/"
    echo "--basebranch=[FOLDER]     Specify the base branch to download from, default is 'main'"
    echo ""
    echo "Examples with download script"
    echo "./install.sh libcester libmetaref libxtd@dev"
    echo "./install.sh --dontclean MrFrenik/gunslinger@master"
    echo "./install.sh --installfolder=./ --tmpfolder=./tmp/ https://github.com/nothings/stb@master"
    echo ""
    echo "Examples from url"
    echo "bash <(curl -s https://exoticlibraries.github.io/magic/install.sh) libcester libmetaref libxtd@dev"
    echo "bash <(curl -s https://exoticlibraries.github.io/magic/install.sh) --dontclean MrFrenik/gunslinger@master"
    echo "bash <(curl -s https://exoticlibraries.github.io/magic/install.sh) --installfolder=./ https://github.com/nothings/stb@master"
    exit 0
}

validate_paths() {
    if [ ! -d "$INSTALLATION_PATH" ]; then
        fail_with_message "The installation path '$INSTALLATION_PATH' does not exist"
    fi
    if [ ! -d "$TMP_FOLDER" ]; then
        fail_with_message "The temp path '$TMP_FOLDER' does not exist"
    fi
    mkdir -p $TMP_FOLDER/EXOITIC_SCRIPT_INSTALLER/archive
    mkdir -p $TMP_FOLDER/EXOITIC_SCRIPT_INSTALLER/extracted_archive
}

# do not download if exist and not overriding
install_libraries() {
    echo "Preparing to install the libraries..."
    for LIBRARY in ${SELECTED_LIBRARIES[@]}; do
        ARG_MATCH=${LIBRARY%@*}
        BRANCH=${LIBRARY##*@}
        if [ "$BRANCH" = "$ARG_MATCH" ]; then BRANCH=$BASE_BRANCH; fi
        poof_out_github_link_for_library $ARG_MATCH $BRANCH
        LIBRARY_ZIP_URL=$ARG_MATCH
        LIBRARY_NAME=${ARG_MATCH%/archive*}
        LIBRARY_NAME=${LIBRARY_NAME##*/}
        download_and_extract_archive $LIBRARY_ZIP_URL $LIBRARY_NAME $BRANCH
    done
    for LIBRARY in ${SELECTED_LIBRARIES[@]}; do
        ARG_MATCH=${LIBRARY%@*}
        BRANCH=${LIBRARY##*@}
        if [ "$BRANCH" = "$ARG_MATCH" ]; then BRANCH=$BASE_BRANCH; fi
        LIBRARY_NAME=${ARG_MATCH%/archive*}
        LIBRARY_NAME=${LIBRARY_NAME##*/}
        detect_header_files_and_install $LIBRARY_NAME $BRANCH
    done
    echo "The libaries has been installed into $INSTALLATION_PATH"
}

download_and_extract_archive() {
    echo "Downloading $1..."
    curl -s $1 -L -o "$TMP_FOLDER/EXOITIC_SCRIPT_INSTALLER/archive/$2.zip"
    unzip -o "$TMP_FOLDER/EXOITIC_SCRIPT_INSTALLER/archive/$2.zip" -d "$TMP_FOLDER/EXOITIC_SCRIPT_INSTALLER/extracted_archive/$2" > /dev/null
}

detect_header_files_and_install() {
    REPO_FOLDER="$TMP_FOLDER/EXOITIC_SCRIPT_INSTALLER/extracted_archive/$1/$1-$2"
    REPO_FOLDER_ITER="$TMP_FOLDER/EXOITIC_SCRIPT_INSTALLER/extracted_archive/$1/$1-$2/*/"
    FOLDERS_WITH_HEADERS_FILE=()
    for DIR in $REPO_FOLDER_ITER; do
        HAS_C_HEADER=$(find $DIR -name *.h)
        HAS_CPP_HEADER=$(find $DIR -name *.hpp)
        if ([ ! -z "$HAS_C_HEADER" ] || [ ! -z "$HAS_CPP_HEADER" ]) && [[ ! " ${DIR[@]} " =~ "test/" ]]; then
            FOLDERS_WITH_HEADERS_FILE+=($DIR)
        fi
    done
    echo "Installing $1..."
    cp $REPO_FOLDER/*.h $INSTALLATION_PATH 2> /dev/null
    cp $REPO_FOLDER/*.hpp $INSTALLATION_PATH 2> /dev/null
    for INCLUDE_FOLDER in ${FOLDERS_WITH_HEADERS_FILE[@]}; do
        if [[ " ${INCLUDE_FOLDER[@]} " =~ "/include" ]]; then
            cp -r $INCLUDE_FOLDER/* $INSTALLATION_PATH
        else
            FOLDER_NAME=$(basename $INCLUDE_FOLDER)
            mkdir -p $INSTALLATION_PATH/$FOLDER_NAME
            cp -r $INCLUDE_FOLDER/* $INSTALLATION_PATH/$FOLDER_NAME
        fi
    done
}

poof_out_github_link_for_library() {
    LIBRARY=$1
    BRANCH=$2
    if [[ " ${LIBRARY[@]} " =~ "github.com" ]]; then
        ARG_MATCH=${LIBRARY%.git*}
        ARG_MATCH="$LIBRARY/archive/$BRANCH.zip"
        
    elif [[ " ${LIBRARY[@]} " =~ "/" ]]; then
        ARG_MATCH="https://github.com/$LIBRARY/archive/$BRANCH.zip"
        
    else
        ARG_MATCH="https://github.com/exoticlibraries/$LIBRARY/archive/$BRANCH.zip"
    fi
}

cleanup_residuals() {
    if [ "$CLEANUP" == "true" ]; then
        echo "Cleaning up temporary installation files and folder..."
        rm -Rf "$TMP_FOLDER/EXOITIC_SCRIPT_INSTALLER"
    fi
}

fail_with_message() {
    echo "Error: $1"
    exit 1
}

check_if_is_root() {
    if [ "$EUID" -ne 0 ]; then 
        IS_ROOT=false
    fi
}

main $@
exit 0