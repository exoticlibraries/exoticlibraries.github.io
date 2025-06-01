
# Installation scripts for C and C++ libraries on github

- `Managing dependencies for C and C++ projects`_
- `Mac, Unix, Linux Script`_
   - `Bash Script Options and Usage`_
   - `Bash Script Examples`_
- `Windows Script`_
   - `Powershell Script Options and Usage`_
   - `Powershell Script Examples`_

## Managing dependencies for C and C++ projects

Managing dependency in C and C++ projects is usually tricky as there is no one standard registry where a library can be downloaded from. 
This might not be true for a Linux system where there is apt-get that installs libraries and programs from PPA but most of the libraries 
are outdated and it a lot of stress to add a library to PPA. Another approach is using Conan which requires the addition of the CMake 
build system into your project.

A better approach is to use a github as a package registry for C projects and install from each project repo since most 
libraries are distributed as source anyways, the closest project to achieving a smooth package registry with less hassle is 
[vcpkg](https://github.com/Microsoft/vcpkg) by Microsoft but this also requires the library to be added to the vcpkg port 
and have vcpkg installed on the system. 

All the above ways of managing packages are all good but I love the way [golang](https://golang.org/) manages packages and is able to simply pull a package 
from the github repo and is immediately available for use in your go project, that the idea behind the two scripts I wrote and I went 
further such that no prerequisite is required to download a C, C++ library from github just the internet and the native shell for 
the operating systems, bash for Unix, Mac and Linux and Powershell for windows. 

The purpose of the script is to be able to download, build (when needed), and install the library without any hassle at all using remote scripts.
Currently, the script can only install headers only libraries from github but I had planned for it to be able to build non header-only library 
if a CMakeLists.txt or Makefile is present in the repo root.

The source for the bash and Powershell scripts:
- [Bash Script](https://github.com/exoticlibraries/exoticlibraries.github.io/blob/main/magic/install.sh)
- [Powershell Script](https://github.com/exoticlibraries/exoticlibraries.github.io/blob/main/magic/install.ps1)

## Mac, Unix, Linux Script

The bash script hosted at https://exoticlibraries.github.io/magic/install.sh can be used remotely or locally 
to install exotic libraries and any headers only library hosted on github into the `/usr/local/include`, 
`/usr/include/` or any specified folder. The script accepts various argument to select what branch of the 
repo to install, where to install the library, the temporary folder for download and extraction of the 
repo archive e.t.c.

To use the script locally the bash script should be downloaded into a folder, it can also be invoked remotely 
using input character + curl.

To use locally replace `bash <(curl -s https://exoticlibraries.github.io/magic/install.sh)` in the examples 
below with `./install.sh`.

### Bash Script Options and Usage

The script accepts various options, to view the help message use the `-h` or `--help` option. 

```bash
bash <(curl -s https://exoticlibraries.github.io/magic/install.sh) -h
```

- `-h, --help`: Displays the script help message and exit.
- `-all`: Install all the exotic libraries.
existing by default. This still downloads the archive though, so it advisable not to specify a library if it 
not to be installed and overridden.
- `--dontclean`: Do not delete the libraries downloaded and extracted archive from the temporary folder.
- `--installfolder=`: Specify where to install the library. The default location is `/usr/local/include/` and if 
the script is executed with superuser (sudo/su) privilege, the default is `/usr/include/`. For example to change 
the installation folder to the current directory add the option `--installfolder=./`
- `--tmpfolder=`: Change where the libraries archive are downloaded and extracted into, the default location is `/tmp/`

### Bash Script Examples

The default github repo branch is **main**, to select which branch to install from add `@branch-name` after the library name 
e.g. *libcester@dev*, *metaref@main*, *MrFrenik/gunslinger@master*, *https://github.com/nothings/stb@master* e.t.c.

To install all the exotic libraries:

```bash
bash <(curl -s https://exoticlibraries.github.io/magic/install.sh) -all
```

To install selected exotic libraries, e.g. libxtd, libcester, libmetaref

```bash
bash <(curl -s https://exoticlibraries.github.io/magic/install.sh) libxtd libcester libmetaref
```

To install non exotic library from a github repo, specify just the repo-owner/repo-name or the absolute github 
link to the repo. E.g. to install [gunslinger](https://github.com/MrFrenik/gunslinger) and [stb](https://github.com/nothings/stb) 
from master branch

```bash
bash <(curl -s https://exoticlibraries.github.io/magic/install.sh) MrFrenik/gunslinger@master https://github.com/nothings/stb@master
```

To install [libcester](https://exoticlibraries.github.io/libcester) and [gunslinger](https://github.com/MrFrenik/gunslinger) 
into the currenct folder with a custom temporary directory

```bash
bash <(curl -s https://exoticlibraries.github.io/magic/install.sh) --installfolder=./ --tmpfolder=../temp/ libcester@main MrFrenik/gunslinger@master
```

## Windows Script

The Powershell script hosted at https://exoticlibraries.github.io/magic/install.ps1 can be used remotely or locally 
to install exotic libraries and any header-only library hosted on github into the detected compilers include paths or any specified folder. 
The following compilers are auto detected and the libraries are installed into their corresponding include paths:

- Clang
- GCC
- MSVC

It is required that the gcc is present in PATH.

The script accept various argument to select what branch of the repo to install, where to install the library, the temporary 
folder for download and extraction of the repo archive e.t.c.

To use locally replace `& $([scriptblock]::Create((New-Object Net.WebClient).DownloadString("https://exoticlibraries.github.io/magic/install.ps1")))` in the examples below with `./install.ps1`.

### Powershell Script Options and Usage

The script accepts various options, to view the help message use the `-H` or `--Help` option. 

```powershell
& $([scriptblock]::Create((New-Object Net.WebClient).DownloadString("https://exoticlibraries.github.io/magic/install.ps1"))) -H
```

- `-H, --Help`: Displays the script help message and exit.
- `--All`: Install all the exotic libraries.
existing by default. This still downloads the archive though, so it advisable not to specify a library if it 
not to be installed and overridden.
- `--DontClean`: Do not delete the libraries downloaded and extracted archive from the temporary folder.
- `--InstallFolder=`: Specify where to install the library. The default location is the include path for detected 
compilers. For example to change the installation folder to the current directory add the option `--installfolder=./`
- `--TmpFolder=`: Change where the libraries archive are downloaded and extracted into, the default location is `C:\Users\<username>\AppData\Local\Temp`

### Powershell Script Examples

The default github repo branch is **main**, to select which branch to install from add `@branch-name` after the library name 
e.g. *libcester@dev*, *metaref@main*, *MrFrenik/gunslinger@master*, *https://github.com/nothings/stb@master* e.t.c.

To install all the exotic libraries:

```powershell
& $([scriptblock]::Create((New-Object Net.WebClient).DownloadString("https://exoticlibraries.github.io/magic/install.ps1"))) --All
```

To install selected exotic libraries, e.g. libxtd, libcester, libmetaref

```powershell
& $([scriptblock]::Create((New-Object Net.WebClient).DownloadString("https://exoticlibraries.github.io/magic/install.ps1"))) libxtd libcester libmetaref
```

To install non exotic library from a github repo, specify just the repo-owner/repo-name or the absolute github 
link to the repo. E.g. to install [gunslinger](https://github.com/MrFrenik/gunslinger) and [stb](https://github.com/nothings/stb) 
from master branch

```powershell
& $([scriptblock]::Create((New-Object Net.WebClient).DownloadString("https://exoticlibraries.github.io/magic/install.ps1"))) MrFrenik/gunslinger@master https://github.com/nothings/stb@master
```

To install [libcester](https://exoticlibraries.github.io/libcester) and [gunslinger](https://github.com/MrFrenik/gunslinger) 
into the currenct folder with a custom temporary directory

```powershell
& $([scriptblock]::Create((New-Object Net.WebClient).DownloadString("https://exoticlibraries.github.io/magic/install.ps1"))) --InstallFolder=./ --TmpFolder=../temp/ libcester@main MrFrenik/gunslinger@master
```

----

- Author: Adewale Azeez
- Date: 08 February, 2022