# Table of Contents

- [Table of Contents](#table-of-contents)
- [Environment Setup](#environment-setup)
  - [Git](#git)
  - [Python](#python)
  - [Visual Studio Code](#visual-studio-code)
  - [WSL](#wsl)
- [Repository](#repository)
- [Toolchain](#toolchain)
- [U-Boot](#u-boot)
- [Linux kernel](#linux-kernel)
- [Copy artifacts in SD card](#copy-artifacts-in-sd-card)
- [Launch](#launch)
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
    libtool-bin make patch python3-dev rsync texinfo unzip wget xz-utils pkg-config \
    libssl-dev libgnutls28-dev gtkterm subversion qemu-system-arm
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

# Toolchain

To build the toolchains, open WSL and execute:
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

To download the reamining toolchains, open WSL and execute:
```
# Download Raspberry Pi 4 toolchain
cd ~
wget https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/binrel/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz
tar --checkpoint=1000 --checkpoint-action=dot -xf arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz
mv arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu x-tools/aarch64-none-linux-gnu
rm arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz
```

Add toolchains to the path:
```
# BeagleBone Black toolchain
PATH=~/x-tools/arm-cortex_a8-linux-gnueabihf/bin:$PATH
export CROSS_COMPILE=arm-cortex_a8-linux-gnueabihf-
export ARCH=arm

# QEMU toolchain
PATH=~/x-tools/arm-unknown-linux-gnueabi/bin:$PATH
export CROSS_COMPILE=arm-unknown-linux-gnueabi-
export ARCH=arm

# Raspberry Pi 4 toolchain
PATH=~/x-tools/aarch64-none-linux-gnu/bin:$PATH
export CROSS_COMPILE=aarch64-none-linux-gnu-
export ARCH=arm64
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

# Raspberry Pi 4 toolchain
aarch64-none-linux-gnu-gcc --version
aarch64-none-linux-gnu-gcc -v
aarch64-none-linux-gnu-gcc --target-help
aarch64-none-linux-gnu-gcc -print-sysroot
ls -la ~/x-tools/aarch64-none-linux-gnu/aarch64-none-linux-gnu/libc
```

# U-Boot

To build U-Boot, open WSL and execute:
```
# Build U-Boot for BeagleBone Black
cd ~/development/repositories/mastering_embedded_linux_programming/u-boot
source ../melp/Chapter02/set-path-arm-cortex_a8-linux-gnueabihf
make distclean
make am335x_evm_defconfig
make
```

# Linux kernel

To build Linux kernel, open WSL and execute:
```
# Build Linux kernel for BeagleBone Black
cd ~/development/repositories/mastering_embedded_linux_programming/linux-stable
PATH=~/x-tools/arm-cortex_a8-linux-gnueabihf/bin:$PATH
export CROSS_COMPILE=arm-cortex_a8-linux-gnueabihf-
export ARCH=arm
make O=./build/bbb mrproper
make O=./build/bbb multi_v7_defconfig
make O=./build/bbb -j 4 zImage
make O=./build/bbb -j 4 modules
make O=./build/bbb dtbs

# Build Linux kernel for QEMU
cd ~/development/repositories/mastering_embedded_linux_programming/linux-stable
PATH=~/x-tools/arm-unknown-linux-gnueabi/bin:$PATH
export CROSS_COMPILE=arm-unknown-linux-gnueabi-
export ARCH=arm
make O=./build/qemu mrproper
make O=./build/qemu versatile_defconfig
make O=./build/qemu -j 4 zImage
make O=./build/qemu -j 4 modules
make O=./build/qemu dtbs

# Build Linux kernel for Raspberry Pi 4
cd ~/development/repositories/mastering_embedded_linux_programming/rpi-linux
PATH=~/x-tools/aarch64-none-linux-gnu/bin:$PATH
export CROSS_COMPILE=aarch64-none-linux-gnu-
export ARCH=arm64
make bcm2711_defconfig
make -j 4

# Copy the kernel image, device tree blobs, and boot parameters to rpi-firmware/boot
cd ~/development/repositories/mastering_embedded_linux_programming
rm rpi-firmware/boot/kernel*
rm rpi-firmware/boot/*.dtb
rm rpi-firmware/boot/overlays/*.dtbo
cp rpi-linux/arch/arm64/boot/Image rpi-firmware/boot/kernel8.img
cp rpi-linux/arch/arm64/boot/dts/broadcom/*.dtb rpi-firmware/boot/
cp rpi-linux/arch/arm64/boot/dts/overlays/*.dtbo rpi-firmware/boot/overlays/

# Create config.txt and cmdline.txt files
cat << EOF > rpi-firmware/boot/config.txt
enable_uart=1
arm_64bit=1
EOF
cat << EOF > rpi-firmware/boot/cmdline.txt
console=serial0,115200 console=tty1 root=/dev/mmcblk0p2 rootwait
EOF
```

# Copy artifacts in SD card

```
cd ~/development/repositories/mastering_embedded_linux_programming

# Identify the SD card name, for example, "sde"
lsblk

# Mount the SD card boot partition
sudo mkdir -p /media/jmfermun/boot
sudo mount /dev/sde1 /media/jmfermun/boot

# BeagleBone Black artifacts
sudo cp u-boot/MLO /media/jmfermun/boot/
sudo cp u-boot/u-boot.img /media/jmfermun/boot/
sudo cp linux-stable/build/bbb/arch/arm/boot/zImage /media/jmfermun/boot/
sudo cp linux-stable/build/bbb/arch/arm/boot/dts/ti/omap/am335x-boneblack.dtb /media/jmfermun/boot/

# Raspberry Pi 4 artifacts
sudo cp -r rpi-firmware/boot/* /media/jmfermun/boot/

# Unmount the SD card boot partition
sudo umount /media/jmfermun/boot
```

# Launch

Launch U-Boot + Linux in BeagleBone Black:
- Turn off BeagleBone Black.
- Insert SD card.
- Connect USB to serial converter to [serial header pins](https://docs.beagleboard.org/boards/beaglebone/black/ch07.html#id12).
- Follow instructions in [Open serial port](#open-serial-port).
- Press (and maintain pressed) S2 button.
- Turn on BeagleBone Black.
- U-Boot output should be available in the serial port terminal.
- Press any key to stop autoboot.
- Execute the following commands in the U-Boot prompt:
    ```
    fatls mmc 0:1
    fatload mmc 0:1 0x80200000 zImage
    fatload mmc 0:1 0x80f00000 am335x-boneblack.dtb
    setenv bootargs console=ttyO0,115200
    bootz 0x80200000 - 0x80f00000
    ```
- Linux output should be available in the serial port terminal.

Launch Linux in Raspberry Pi 4:
- Turn off Raspberry Pi 4.
- Insert SD card.
- Connect USB to serial converter to [serial header pins](https://learn.adafruit.com/adafruits-raspberry-pi-lesson-5-using-a-console-cable/connect-the-lead).
- Follow instructions in [Open serial port](#open-serial-port).
- Turn on Raspberry Pi 4.
- Linux output should be available in the serial port terminal.

Launch Linux in QEMU:
- Execute the following commands:
```
cd ~/development/repositories/mastering_embedded_linux_programming
export QEMU_AUDIO_DRV=none
qemu-system-arm \
    -m 256M \
    -nographic \
    -M versatilepb \
    -kernel linux-stable/build/qemu/arch/arm/boot/zImage \
    -append "console=ttyAMA0,115200" \
    -dtb linux-stable/build/qemu/arch/arm/boot/dts/arm/versatile-pb.dtb
```

# Miscellaneous

## SD card format

Use MiniTool Partition Wizard in Windows to format the SD card:
- BeagleBone Black:
    - Partition 1: FAT32, 64 MiB, set as active (bootable).
    - Partition2: ext4, 1 GiB.
- Raspberry Pi 4:
    - Partition 1: FAT32, 1 GiB, set as active (bootable).

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
