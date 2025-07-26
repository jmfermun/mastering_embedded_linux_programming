#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Change to respository root directory.
cd "$(dirname "$0")"/..

# Add submodules.
git submodule add https://github.com/PacktPublishing/Mastering-Embedded-Linux-Programming-Third-Edition.git melp
git submodule add https://github.com/crosstool-ng/crosstool-ng.git crosstool-ng
git submodule add https://source.denx.de/u-boot/u-boot.git u-boot
git submodule add git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-stable
git submodule add https://github.com/raspberrypi/linux.git rpi-linux
git submodule add --depth 1 https://github.com/raspberrypi/firmware.git rpi-firmware
git config -f .gitmodules submodule.rpi-firmware.shallow true
git submodule add git://busybox.net/busybox.git busybox
git submodule add git://git.buildroot.net/buildroot buildroot
