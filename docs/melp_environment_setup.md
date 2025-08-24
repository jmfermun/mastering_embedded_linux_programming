# Table of Contents

- [Table of Contents](#table-of-contents)
- [Environment Setup](#environment-setup)
  - [Git](#git)
  - [Python](#python)
  - [Visual Studio Code](#visual-studio-code)
  - [WSL](#wsl)
- [Repository](#repository)
- [Miscellaneous](#miscellaneous)
  - [SD card format](#sd-card-format)
  - [Attach SD card to WSL](#attach-sd-card-to-wsl)
  - [Open serial port](#open-serial-port)

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

- In Windows, go to %USERPROFILE% and create the file .wslconfig with the following contents:
    ```
    [wsl2]
    networkingMode=mirrored
    ```
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
    Set-NetFirewallHyperVVMSetting -Name '{40E0AC32-46A5-438A-A0B2-2B479E8F2E90}' -DefaultInboundAction Allow
    ```
- Open WSL and execute:
    ```
    sudo apt update && sudo apt upgrade
    sudo apt-get install autoconf automake bison bzip2 cmake \
    flex g++ gawk gcc gettext git gperf help2man libncurses5-dev libstdc++6 libtool \
    libtool-bin make patch python3-dev rsync texinfo unzip wget xz-utils pkg-config \
    libssl-dev libgnutls28-dev gtkterm subversion qemu-system-arm cpio genext2fs dosfstools \
    nfs-kernel-server tftpd-hpa uml-utilities
    git config --global user.name "Juan Manuel Fernández Muñoz"
    git config --global user.email "jmfermun@gmail.com"
    git config --global color.ui auto
    git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"
    ```
- Open PowerShell and execute:
    ```
    git config --global credential.helper wincred
    ```
- Download and install [usbipd-win](https://github.com/dorssel/usbipd-win/releases).
- Download [Etcher](https://github.com/balena-io/etcher/releases/) debian package and install it with the command:
    ```
    sudo apt install ./balena-etcher_2.1.3_amd64.deb
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

# Miscellaneous

## SD card format

Use MiniTool Partition Wizard in Windows to format the SD card:
- BeagleBone Black:
    - Partition 1: FAT32, 64 MiB, set as active (bootable).
    - Partition2: ext4, 1 GiB.
- Raspberry Pi 4:
    - Partition 1: FAT32, 1 GiB, set as active (bootable).

If you have an SD card reader supported by WSL, execute:
```
cd ~/development/repositories/mastering_embedded_linux_programming
bash melp/format-sdcard.sh sdf
```

## Attach SD card to WSL

Open PowerShell as administrator:
```
# Identify the "USB storage device" bus ID, for example, "1-2"
usbipd list

# Attach SD card to WSL
usbipd bind --busid 1-2
usbipd attach --wsl --busid 1-2

# Detach SD card from WSL
usbipd detach --busid 1-2
```

## Open serial port

Open PowerShell as administrator:
```
# Identify the "USB serial device (COMX)" bus ID, for example, "1-2"
usbipd list

# Attach serial port to WSL
usbipd bind --busid 1-2
usbipd attach --wsl --busid 1-2

# Detach serial port from WSL (after you finish the work)
usbipd detach --busid 1-2
```

Open WSL:
```
# Open the serial port
ls /dev
gtkterm -p /dev/ttyUSB0 -s 115200
```
