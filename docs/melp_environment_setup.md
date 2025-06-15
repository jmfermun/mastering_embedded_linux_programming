# Table of Contents

- [Table of Contents](#table-of-contents)
- [Environment Setup](#environment-setup)
  - [Git](#git)
  - [Python](#python)
  - [Visual Studio Code](#visual-studio-code)
  - [WSL](#wsl)
- [Repository](#repository)
- [Crostool-ng toolchains](#crostool-ng-toolchains)

# Environment Setup

## Git

- Download [Git for Windows](https://git-scm.com/downloads/win) and install it. Options:
    - Use Visual Studio Code as Git's default editor.
- Download [TortoiseGit](https://tortoisegit.org/download/) and install it. Options:
    - Add the user name *Juan Manuel Fernández Muñoz*.
    - Add the email *jmfermun@gmail.com*.

## Python

- Go to the Microsoft Store and install the latest version of Python.

## Visual Studio Code

- Download the system installer of [Visual Studio Code](https://code.visualstudio.com/Download) and install it.
- Install the following extensions:
    - [C/C++ (Microsoft)](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools).
    - [Makefile Tools (Microsoft)](https://marketplace.visualstudio.com/items?itemName=ms-vscode.makefile-tools).
    - [Python (Microsoft)](https://marketplace.visualstudio.com/items?itemName=ms-python.python).
    - [WSL (Microsoft)](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl).
    - [Markdown All in One (Yu Zhang)](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one).
    - [PlantUML (jebbs)](https://marketplace.visualstudio.com/items?itemName=jebbs.plantuml).

## WSL

- Open PowerShell and execute:
    ```
    wsl --install -d Ubuntu-24.04
    # Options:
    # - Configure the unix user jmfermun.
    # - Enter the password ?.
    wsl --set-default Ubuntu-24.04
    ```
- Open WSL and execute:
    ```
    sudo nano /etc/wsl.conf
    # Add the lines:
    # [interop]
    # appendWindowsPath=false
    ```
- Open PowerShell and execute:
    ```
    wsl --shutdown
    ```
- Open WSL and execute:
    ```
    sudo apt update && sudo apt upgrade
    sudo apt-get install autoconf automake bison bzip2 cmake \
    flex g++ gawk gcc gettext git gperf help2man libncurses5-dev libstdc++6 libtool \
    libtool-bin make patch python3-dev rsync texinfo unzip wget xz-utils pkg-config
    git config --global user.name "Juan Manuel Fernández Muñoz"
    git config --global user.email "jmfermun@gmail.com"
    git config --global color.ui auto
    git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"
    ```
- Open PowerShell and execute:
    ```
    git config --global credential.helper wincred
    ```

Notes:
- To uninstall a distribution, open PowerShell and execute:
    ```
    wsl --list --verbose
    wsl --unregister Ubuntu-24.04
    wsl --list --verbose
    ```
- To check the Ubuntu version, open WSL and execute:
    ```
    lsb_release -a
    ```

# Repository

- Open WSL and execute:
    ```
    mkdir -p ~/development/repositories
    cd ~/development/repositories
    git clone -b main https://github.com/jmfermun/mastering_embedded_linux_programming.git
    cd ~/development/repositories/mastering_embedded_linux_programming
    bash ./script/init_submodule.sh
    ```

# Crostool-ng toolchains

- To build the toolchains, open WSL and execute:
```
# Note: perform the build using directly the ubuntu shell, not through vscode to avoid strange errors.

# Build crostool-ng
cd ~/development/repositories/mastering_embedded_linux_programming/crosstool-ng
./bootstrap
./configure --prefix=${PWD}
make
make install

# Build BeagleBone Black toolchain
cd ~/development/repositories/mastering_embedded_linux_programming/crosstool-ng
bin/ct-ng distclean
bin/ct-ng arm-cortex_a8-linux-gnueabi
bin/ct-ng menuconfig
# Paths and misc options -> Render the toolchain read-only -> <N> excludes
# Target options -> Floating point -> hardware (FPU)
# Target options -> Use specific FPU -> neon
# Save and exit
bin/ct-ng build
# Toolchain location: ~/x-tools/arm-cortex_a8-linux-gnueabihf

# Build QEMU toolchain
cd ~/development/repositories/mastering_embedded_linux_programming/crosstool-ng
bin/ct-ng distclean
bin/ct-ng arm-unknown-linux-gnueabi
bin/ct-ng menuconfig
# Paths and misc options -> Render the toolchain read-only -> <N> excludes
bin/ct-ng build
# Toolchain location: ~/x-tools/arm-unknown-linux-gnueabi
```

Add toolchains to the path:
```
# BeagleBone Black toolchain
PATH=~/x-tools/arm-cortex_a8-linux-gnueabihf/bin:$PATH

# QEMU toolchain
PATH=~/x-tools/arm-unknown-linux-gnueabi/bin:$PATH
```

Get information:
```
# BeagleBone Black toolchain
arm-cortex_a8-linux-gnueabihf-gcc --version
arm-cortex_a8-linux-gnueabihf-gcc -v
arm-cortex_a8-linux-gnueabihf-gcc --target-help
arm-cortex_a8-linux-gnueabihf-gcc -print-sysroot
ls -la ~/x-tools/arm-cortex_a8-linux-gnueabihf/arm-cortex_a8-linux-gnueabihf/sysroot

# QEMU toolchain
arm-unknown-linux-gnueabi-gcc --version
arm-unknown-linux-gnueabi-gcc -v
arm-unknown-linux-gnueabi-gcc --target-help
arm-unknown-linux-gnueabi-gcc -print-sysroot
ls -la ~/x-tools/arm-unknown-linux-gnueabi/arm-unknown-linux-gnueabi/sysroot
```
