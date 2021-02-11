
# This script downloads exotic libraries for Windows systems.
# Any header only library hosted on github with the include folder in the main tree
# can be installed using this script. Alternatively the absolute path to the header file 
# on the internet can be specified, it will be downloaded and installed.
#
# The libraries is installed for the following compilers if present on the system
#  - Clang
#  - GCC
#  - MSVC
# 
# Sample Usage:
# To view help
#     Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://exoticlibraries.github.io/magic/install.ps1')) -H
#     Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://exoticlibraries.github.io/magic/install.ps1')) --Help
#
# To install libxtd
#     Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://exoticlibraries.github.io/magic/install.ps1')) libxtd
# 
# To install libcester
#     Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://exoticlibraries.github.io/magic/install.ps1')) libcester
# 
# To install libxtd and libcester
#     Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://exoticlibraries.github.io/magic/install.ps1')) libxtd libcester
# 
# To install gunslinger from github from master branch
#     Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://exoticlibraries.github.io/magic/install.ps1')) MrFrenik/gunslinger@master
# 
# To install stb from github from master branch
#     Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://exoticlibraries.github.io/magic/install.ps1')) https://github.com/nothings/stb@master
# 
# License: MIT
# Author: Adewale Azeez <azeezadewale98@gmail.com>

$Global:VERSION="v2.0"
$Global:LICENSE="MIT"
$Global:YEAR="2021"
$Global:AUTHOR="Adewale Azeez"
$Global:SELECTED_LIBRARIES = New-Object System.Collections.Generic.List[string]
$Global:EXOTIC_LIBRARIES = New-Object System.Collections.Generic.List[string]
$Global:IS_ADMIN=([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$Global:ARG_MATCH=""
$Global:EXTRACTED_ARG_VALUE=""
$Global:INSTALLATION_PATHS = New-Object System.Collections.Generic.List[string]
$Global:TMP_FOLDER=[System.IO.Path]::GetTempPath()
$Global:CLEANUP=$true
$Global:Help=$false

Write-Output "Exotic Libraries Magic Install Script $Global:VERSION"
Write-Output "The $Global:LICENSE License Copyright (c) $Global:YEAR $Global:AUTHOR"
$OLD_CURRENT_DIRECTORY = [Environment]::CurrentDirectory
[Environment]::CurrentDirectory = Get-Location

Function Main {
    param([string[]] $paramargs)
    
    Add-Exotic-Libraries
    $paramargs | ForEach-Object {
        Match-And-Extract-Argument $_
        If ($Global:ARG_MATCH -eq "-H" -or $Global:ARG_MATCH -eq "--Help") {
            Print-Help
            Return 0

        } ElseIf ($Global:ARG_MATCH -eq "--DontClean") {
            $Global:CLEANUP=$false
            
        } ElseIf ($Global:ARG_MATCH -eq "--InstallFolder") {
            $Global:INSTALLATION_PATHS.Add([System.IO.Path]::GetFullPath($Global:EXTRACTED_ARG_VALUE))
            
        } ElseIf ($Global:ARG_MATCH -eq "--TmpFolder") {
            $Global:TMP_FOLDER = [System.IO.Path]::GetFullPath($Global:EXTRACTED_ARG_VALUE)
            
        } ElseIf ($Global:ARG_MATCH -eq "--All") {
            $Global:EXOTIC_LIBRARIES | ForEach-Object {
                $Global:SELECTED_LIBRARIES.Add($_)
            }
            
        } Else {
            If ($Global:ARG_MATCH.Contains("--")) {
                Fail-With-Message "Unknow option '$Global:ARG_MATCH'"
            }
            If (-not $Global:SELECTED_LIBRARIES.Contains($Global:ARG_MATCH)) {
                $Global:SELECTED_LIBRARIES.Add($Global:ARG_MATCH)
            }
        }
    }
    Validate-Paths
    Install-Libraries
    Cleanup-Residuals
}

Function Match-And-Extract-Argument{
    Param([string]$Arg)

    $Splited=$Arg.Split("=")
    $Global:ARG_MATCH=$Splited[0]
    $Global:EXTRACTED_ARG_VALUE=$Splited[1]
}

Function Print-Help {
    Write-Output "Usage: ./install.ps1 [OPTIONS] [LIBRARIES...]"
    Write-Output ""
    Write-Output "[LIBRARIES..]: The headers only libraries to install e.g. libcester@dev nothings/stb@master"
    Write-Output "[OPTIONS]    : The script options"
    Write-Output ""
    Write-Output "The OPTIONS include:"
    Write-Output "-H --Help          Display this help message and exit"
    Write-Output "--All              Install all exotic libraries"
    Write-Output "--DontClean        Skip cleanup , leave the downloaded and extracted archive in the temp folder"
    Write-Output "--InstallFolder=[FOLDER] Specify the folder to install the library into, default is /usr/local/include"
    Write-Output "--TmpFolder=[FOLDER]     Specify the folder to download archive and tmp files, default is /tmp/"
    Write-Output ""
    Write-Output "Examples with download script"
    Write-Output "./install.ps1 libcester libmetaref libxtd@dev"
    Write-Output "./install.ps1 --DontClean MrFrenik/gunslinger@master"
    Write-Output "./install.ps1 --InstallFolder=./ --TmpFolder=./tmp/ https://github.com/nothings/stb@master"
    Write-Output ""
    Write-Output "Examples from url"
    Write-Output "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://exoticlibraries.github.io/magic/install.ps1')) libcester libmetaref libxtd@dev"
    Write-Output "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://exoticlibraries.github.io/magic/install.ps1')) --DontClean MrFrenik/gunslinger@master"
    Write-Output "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://exoticlibraries.github.io/magic/install.ps1')) --InstallFolder=./ https://github.com/nothings/stb@master"
}

Function Validate-Paths {
    If ($Global:INSTALLATION_PATHS.Count -eq 0) {
        If ($Global:IS_ADMIN -eq $False) {
            Fail-With-Message "You need to run the shell as Admin if you want to install in detected installed compiler include paths"
        }
        Detect-Installed-Compilers-Include-Paths
        $Global:INSTALLATION_PATHS | ForEach-Object {
            Write-Output " => $_"
        }
    } Else {
        $Global:INSTALLATION_PATHS | ForEach-Object {
            If ( -not [System.IO.Directory]::Exists($_)) {
                Fail-With-Message "The installation path '$_' does not exist"
            }
        }
    }
    If ( -not [System.IO.Directory]::Exists($Global:TMP_FOLDER)) {
        Fail-With-Message "The temp path '$Global:TMP_FOLDER' does not exist"
    }
    New-Item -Force "$Global:TMP_FOLDER/EXOITIC_SCRIPT_INSTALLER/archive" -ItemType Directory > $null
    New-Item -Force "$Global:TMP_FOLDER/EXOITIC_SCRIPT_INSTALLER/extracted_archive" -ItemType Directory > $null
}

Function Find-Include-Folder-With-Command {
    Param(
        [string]$command
    )

    $CmdOutput = cmd /c $command '2>&1'
    ForEach ($Line in $CmdOutput) {
        if ($Line.Contains("/bin") -or $Line.Contains("\bin")) {
            $IncludePath, $x = $Line -split ("bin") + "bin"
            $IncludePath = $IncludePath -split (":")
            $IncludePath = $IncludePath[$IncludePath.Length-1]
            $IncludePath = $Line.SubString($Line.IndexOf($IncludePath)-2, 2) + $IncludePath
            $IncludePath = ($IncludePath -split ("bin"))[0] + "bin"
        }
    }
    if (-not $IncludePath) {
        Return
    }
    Get-ChildItem -Path "$IncludePath/../" -Filter windows.h -Recurse | Foreach-Object { 
        $APath = [System.IO.Directory]::GetParent($_.FullName).FullName
    }
    # Barren C++ only compiler e.g CLANG
    If (-not $APath) {
        Get-ChildItem -Path "$IncludePath/../" -Filter stdbool.h -Recurse | Foreach-Object { 
            $APath = [System.IO.Directory]::GetParent($_.FullName).FullName
        }
    }
    If ($APath) {
        $Global:INSTALLATION_PATHS.Add($APath)
    }
}

Function Find-Include-Folder-With-Path {
    Param(
        [string]$path
    )

    Get-ChildItem -Path $path -Filter windows.h -Recurse -ErrorAction SilentlyContinue | Foreach-Object { 
        $APath = [System.IO.Directory]::GetParent($_.FullName).FullName
    }
    If (-not $APath) {
        Get-ChildItem -Path $path -Filter setjmp.h -Recurse -ErrorAction SilentlyContinue | Foreach-Object { 
            $APath = [System.IO.Directory]::GetParent($_.FullName).FullName
        }
    }
    If (-not $APath) {
        Get-ChildItem -Path $path -Filter stdbool.h -Recurse -ErrorAction SilentlyContinue | Foreach-Object { 
            $APath = [System.IO.Directory]::GetParent($_.FullName).FullName
        }
    }
    If ($APath) {
        $Global:INSTALLATION_PATHS.Add($APath)
    }
}
Function Detect-Installed-Compilers-Include-Paths {
    Write-Output "Trying to detect headers paths for installed compilers..."
    Find-Include-Folder-With-Command "clang --version"
    Find-Include-Folder-With-Command "gcc -v"
    Find-Include-Folder-With-Path "C:\Program Files\Microsoft Visual Studio\"
    Find-Include-Folder-With-Path "C:\Program Files (x86)\Microsoft Visual Studio\"
    Find-Include-Folder-With-Path "C:\Program Files\LLVM\"
    Find-Include-Folder-With-Path "C:\Program Files (x86)\LLVM\"
}

Function Install-Libraries {
    Write-Output "Preparing to install the libraries..."
    $Global:SELECTED_LIBRARIES | ForEach-Object {
        $Splited=$_.Split("@")
        $NameOnly=$Splited[0]
        If ($NameOnly.Contains(".git")) {
            $NameOnly=$NameOnly.SubString(0, $NameOnly.LastIndexOf('.git'))
        }
        $BRANCH=$Splited[1]
        If (-not $BRANCH -or $BRANCH -eq "") {
            $BRANCH="main"
        }
        $LIBRARY_ZIP_URL = Poof-Out-Github-Link-For-Library $NameOnly $BRANCH
        $LIBRARY_NAME = $LIBRARY_ZIP_URL.SubString(0, $LIBRARY_ZIP_URL.IndexOf("/archive"))
        $LIBRARY_NAME = $LIBRARY_NAME.SubString($LIBRARY_NAME.LastIndexOf("/")+1)
        Download-And-Extract-Archive $LIBRARY_ZIP_URL $LIBRARY_NAME $BRANCH
    }
    $Global:SELECTED_LIBRARIES | ForEach-Object {
        $Splited=$_.Split("@")
        $NameOnly=$Splited[0]
        If ($NameOnly.Contains(".git")) {
            $NameOnly=$NameOnly.SubString(0, $NameOnly.LastIndexOf('.git'))
        }
        $BRANCH=$Splited[1]
        If (-not $BRANCH -or $BRANCH -eq "") {
            $BRANCH="main"
        }
        $LIBRARY_NAME = $NameOnly.SubString($NameOnly.LastIndexOf("/")+1)
        Detect-Header-Files-And-Install $LIBRARY_NAME $BRANCH
    }
    Write-Output "The libaries has been installed"
}

Function Download-And-Extract-Archive {
    Write-Output "Downloading $($args[0])..."
    Invoke-WebRequest $args[0] -OutFile "$Global:TMP_FOLDER/EXOITIC_SCRIPT_INSTALLER/archive/$($args[1]).zip"
    Expand-Archive -Force "$Global:TMP_FOLDER/EXOITIC_SCRIPT_INSTALLER/archive/$($args[1]).zip" -DestinationPath "$Global:TMP_FOLDER/EXOITIC_SCRIPT_INSTALLER/extracted_archive/$($args[1])" > $null
}

Function Detect-Header-Files-And-Install {
    $REPO_FOLDER=[System.IO.Path]::GetFullPath("$Global:TMP_FOLDER/EXOITIC_SCRIPT_INSTALLER/extracted_archive/$($args[0])/$($args[0])-$($args[1])")
    $FOLDERS_WITH_HEADERS_FILE = New-Object System.Collections.Generic.List[string]
    Get-ChildItem -Recurse -Directory $REPO_FOLDER | ForEach-Object {
        $FOLDER_PATH=$_.FullName
        Get-ChildItem -Path $FOLDER_PATH -Filter *.h -Recurse -ErrorAction SilentlyContinue | Foreach-Object {
            If (-not $FOLDERS_WITH_HEADERS_FILE.Contains($FOLDER_PATH)) {
                $FOLDERS_WITH_HEADERS_FILE.Add($FOLDER_PATH)
            }
        }
        Get-ChildItem -Path $FOLDER_PATH -Filter *.hpp -Recurse -ErrorAction SilentlyContinue | Foreach-Object {
            If (-not $FOLDERS_WITH_HEADERS_FILE.Contains($FOLDER_PATH)) {
                $FOLDERS_WITH_HEADERS_FILE.Add($FOLDER_PATH)
            }
        }
    }
    Write-Output "Installing $($args[0])..."
    For ($index = 0; $index -lt $FOLDERS_WITH_HEADERS_FILE.Count; $index++) {
        $FOLDERS_WITH_HEADERS_FILE[$index]=$REPO_FOLDER + "\" + $FOLDERS_WITH_HEADERS_FILE[$index].Replace($REPO_FOLDER + "\", "").Split("\")[0]
    }
    $Global:INSTALLATION_PATHS | ForEach-Object {
        $INSTALLATION_PATH=$_
        Copy-Item -Force $REPO_FOLDER/*.h $INSTALLATION_PATH 2> $null
        Copy-Item -Force $REPO_FOLDER/*.hpp $INSTALLATION_PATH 2> $null
        $FOLDERS_WITH_HEADERS_FILE | ForEach-Object {
            $INCLUDE_FOLDER=$_
            If ($INCLUDE_FOLDER.Contains("include")) {
                Copy-Item -Force -Recurse $INCLUDE_FOLDER/* $INSTALLATION_PATH > $null
            } else {
                $FOLDER_NAME=[System.IO.Path]::GetFileName($INCLUDE_FOLDER)
                New-Item -Force -ItemType Directory $INSTALLATION_PATH/$FOLDER_NAME > $null
                Copy-Item -Force -Recurse $INCLUDE_FOLDER/* $INSTALLATION_PATH/$FOLDER_NAME > $null
            }
        }
    }
}

Function Poof-Out-Github-Link-For-Library {
    $NameOnly=$args[0]
    $Branch=$args[1]
    If ($NameOnly.Contains("github.com")) {
        return "$NameOnly/archive/$BRANCH.zip"

    } Elseif ($NameOnly.Contains("/")) {
        return "https://github.com/$NameOnly/archive/$Branch.zip"

    } Else {
        return "https://github.com/exoticlibraries/$NameOnly/archive/$Branch.zip"
    }
}

Function Cleanup-Residuals {
    if ($Global:CLEANUP) {
        Write-Output "Cleaning up temporary installation files and folder..."
        Remove-Item -Recurse -Force $Global:TMP_FOLDER/EXOITIC_SCRIPT_INSTALLER
    }
}

Function Add-Exotic-Libraries {
    $Global:EXOTIC_LIBRARIES.Add("libxtd")
    $Global:EXOTIC_LIBRARIES.Add("libcester")
    $Global:EXOTIC_LIBRARIES.Add("libmetaref")
}

Function Fail-With-Message {
    [Environment]::CurrentDirectory = $OLD_CURRENT_DIRECTORY
    throw "$args"
}

Main $args
[Environment]::CurrentDirectory = $OLD_CURRENT_DIRECTORY