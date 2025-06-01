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
# To install uWebSockets from github from master branch and specify the include folders
#     bash <(curl -s https://exoticlibraries.github.io/magic/install.sh) --source-folders=src,examples https://github.com/uNetworking/uWebSockets@master 
# 
# To install uWebSockets from github from master branch and specify the include folders and ignore hierarchy in install folder
#     bash <(curl -s https://exoticlibraries.github.io/magic/install.sh) --source-folders=src,examples https://github.com/uNetworking/uWebSockets@master --flat
# 
# To install uWebSockets from github from master branch and specify the include folders and ignore hierarchy in install folder with build command
#     bash <(curl -s https://exoticlibraries.github.io/magic/install.sh) --source-folders=src,examples https://github.com/uNetworking/uWebSockets@master --flat --build-command=make
# 
# License: MIT
# Author: Adewale Azeez <iamthecarisma@gmail.com>

VERSION=v2.0
LICENSE=MIT
YEAR=2022
AUTHOR="Adewale Azeez"
BASE_BRANCH=main
SELECTED_LIBRARIES=()
EXOTIC_LIBRARIES=(
    libxtd
    libcester
    libmetaref
    libcline
    liblogax
)
IS_ROOT=true
BUILD_COMMAND=
ARG_MATCH=false
SOURCE_FOLDERS=()
EXTRACTED_ARG_VALUE=
INSTALLATION_PATH=/usr/local/include
TMP_FOLDER=/tmp/
CLEANUP=true
FLAT_INSTALLATION=false

echo "Exotic Libraries Magic Install Script $VERSION"
echo "The $LICENSE License Copyright (c) $YEAR $AUTHOR"

main() {
    check_if_is_root
    if [ "$IS_ROOT" == "true" ]; then
        if [[ -d "/usr/include" ]];  then
            INSTALLATION_PATH=/usr/include
        fi
        if [[ ! -d "$INSTALLATION_PATH" ]];  then
            mkdir -p "$INSTALLATION_PATH"
        fi
    fi
    for ARG in "$@"
    do
        match_and_extract_argument $ARG
        if [[ "-h" == "$ARG_MATCH" || "--help" == "$ARG_MATCH" ]]; then
            print_help

        elif [[ "--flat" == "$ARG_MATCH" ]]; then
            FLAT_INSTALLATION=true

        elif [[ "--dontclean" == "$ARG_MATCH" ]]; then
            CLEANUP=false

        elif [[ "--installfolder" == "$ARG_MATCH" ]]; then
            INSTALLATION_PATH=$EXTRACTED_ARG_VALUE

        elif [[ "--tmpfolder" == "$ARG_MATCH" ]]; then
            TMP_FOLDER=$EXTRACTED_ARG_VALUE

        elif [[ "--basebranch" == "$ARG_MATCH" ]]; then
            BASE_BRANCH=$EXTRACTED_ARG_VALUE

        elif [[ "--build-command" == "$ARG_MATCH" ]]; then
            BUILD_COMMAND=$EXTRACTED_ARG_VALUE

        elif [[ "--source-folders" == "$ARG_MATCH" ]]; then
            IFS=',' read -ra SOURCE_FOLDERS <<< "$EXTRACTED_ARG_VALUE"

        elif [[ "--gcclib2clang" == "$ARG_MATCH" ]]; then
            copy_gcc_libs_to_clang
            return

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
    EXTRACTED_ARG_VALUE=${EXTRACTED_ARG_VALUE/\\s/" "}
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
    echo "--flat             Install all headers and source in the install folder without source folder hierarchy"
    echo "--dontclean        Skip cleanup , leave the downloaded and extracted archive in the temp folder"
    echo "--gcclib2clang     Make c and c++ header in gcc installation available for clang"
    echo "--installfolder=[FOLDER] Specify the folder to install the library into, default is /usr/local/include"
    echo "--tmpfolder=[FOLDER]      Specify the folder to download archive and tmp files, default is /tmp/"
    echo "--basebranch=[FOLDER]     Specify the base branch to download from, default is 'main'"
    echo "--source-folders=[FOLDER,..]     Specify the folders to search for the header and source files"
    echo "--build-command="COMMAND"        Execute specific command after downloading"
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

copy_gcc_libs_to_clang() {
    echo "The '--gcclib2clang' command only performs on Windows"
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
    if [[ $SOURCE_FOLDERS != "" ]];
    then
        ACTIVE_PWD=$(pwd)
        cd "$TMP_FOLDER/EXOITIC_SCRIPT_INSTALLER/extracted_archive/$2/$2-$3"
        echo "Executing Post Download Command: $BUILD_COMMAND"
        echo "  Folder: $TMP_FOLDER/EXOITIC_SCRIPT_INSTALLER/extracted_archive/$2/$2-$3/"
        $BUILD_COMMAND
        cd $ACTIVE_PWD
    fi
}

detect_header_files_and_install() {
    REPO_FOLDER="$TMP_FOLDER/EXOITIC_SCRIPT_INSTALLER/extracted_archive/$1/$1-$2"
    REPO_FOLDER_ITER="$TMP_FOLDER/EXOITIC_SCRIPT_INSTALLER/extracted_archive/$1/$1-$2/*/"
    FOLDERS_WITH_HEADERS_FILE=()
    FOLDERS_WITH_ARCHIVED_BINARIES_FILE=()
    
    for DIR in $REPO_FOLDER_ITER; do
        if [[ $SOURCE_FOLDERS == "" ]];
        then
            # check headers
            HAS_C_HEADER=$(find $DIR -name *.h)
            HAS_CPP_HEADER=$(find $DIR -name *.hpp)
            if ([ ! -z "$HAS_C_HEADER" ] || [ ! -z "$HAS_CPP_HEADER" ]) && [[ ! " ${DIR[@]} " =~ "test/" ]]; then
                FOLDERS_WITH_HEADERS_FILE+=($DIR)
            fi
        fi
        # check binaries
        HAS_ARCHIVE=$(find $DIR -name *.a)
        HAS_NIX_LIBRARIES=$(find $DIR -name *.lib)
        HAS_WIN_LIBRARIES=$(find $DIR -name *.dll)
        HAS_MAC_LIBRARIES=$(find $DIR -name *.dylib)
        if ([ ! -z "$HAS_ARCHIVE" ] || [ ! -z "$HAS_NIX_LIBRARIES" ] || [ ! -z "$HAS_WIN_LIBRARIES" ] || [ ! -z "$HAS_MAC_LIBRARIES" ]) && [[ ! " ${DIR[@]} " =~ "test/" ]]; then
            FOLDERS_WITH_ARCHIVED_BINARIES_FILE+=($DIR)
        fi
    done
    for SOURCE_FOLDER in "${SOURCE_FOLDERS[@]}"; do
        FOLDERS_WITH_HEADERS_FILE+=($TMP_FOLDER/EXOITIC_SCRIPT_INSTALLER/extracted_archive/$1/$1-$2/$SOURCE_FOLDER)
    done
    echo "Installing $1..."
    cp $REPO_FOLDER/*.h $INSTALLATION_PATH 2> /dev/null
    cp $REPO_FOLDER/*.hpp $INSTALLATION_PATH 2> /dev/null
    for INCLUDE_FOLDER in ${FOLDERS_WITH_HEADERS_FILE[@]}; do
        if [[ " ${INCLUDE_FOLDER[@]} " =~ "/include" ]]; then
            cp -r $INCLUDE_FOLDER/* $INSTALLATION_PATH
        else
            FOLDER_NAME=
            if [ "$FLAT_INSTALLATION" == "false" ]; then
                FOLDER_NAME=$(basename $INCLUDE_FOLDER)
                mkdir -p $INSTALLATION_PATH/$FOLDER_NAME
            fi
            cp -r $INCLUDE_FOLDER/* $INSTALLATION_PATH/$FOLDER_NAME
        fi
    done

    echo "Installing binaries 3hjfg3ghf2ghf... $FOLDERS_WITH_ARCHIVED_BINARIES_FILE"
    install_binaries_files $REPO_FOLDER $FOLDERS_WITH_ARCHIVED_BINARIES_FILE
}

install_binaries_files() {
    REPO_FOLDER=$1
    FOLDERS_WITH_ARCHIVED_BINARIES_FILE=$2
    echo "Installing binaries..."
    for BINARY_FOLDER in ${FOLDERS_WITH_ARCHIVED_BINARIES_FILE[@]}; do
        copy_matching_binaries_files $BINARY_FOLDER
    done
    copy_matching_binaries_files $REPO_FOLDER
}

copy_matching_binaries_files() {
    FOLDER=$1
    for BINARY_FILE in $FOLDER/*.a; do
        if [[ -f "$BINARY_FILE" ]];  then
            echo "  Copying the binary - $BINARY_FILE"; cp -r $BINARY_FILE $INSTALLATION_PATH
        fi
    done
    for BINARY_FILE in $FOLDER/*.lib; do
        if [[ -f "$BINARY_FILE" ]];  then
            echo "  Copying the binary - $BINARY_FILE"; cp -r $BINARY_FILE $INSTALLATION_PATH
        fi
    done
    for BINARY_FILE in $FOLDER/*.dll; do
        if [[ -f "$BINARY_FILE" ]];  then
            echo "  Copying the binary - $BINARY_FILE"; cp -r $BINARY_FILE $INSTALLATION_PATH
        fi
    done
    for BINARY_FILE in $FOLDER/*.dylib; do
        if [[ -f "$BINARY_FILE" ]];  then
            echo "  Copying the binary - $BINARY_FILE"; cp -r $BINARY_FILE $INSTALLATION_PATH
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