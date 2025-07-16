#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Change to respository root directory.
cd "$(dirname "$0")"/..

# Initialize the repository submodules.
git submodule update --init --force --remote --recursive

# Checkout the correct release of crosstool-NG.
cd crosstool-ng
git checkout crosstool-ng-1.27.0

# Checkout the correct branch of Mastering Embedded Linux Programming Third Edition.
cd ../melp
git checkout master

# Checkout the correct branch of U-Boot.
cd ../u-boot
git checkout v2025.04

# Checkout the correct branch of Linux.
cd ../linux-stable
git checkout v6.15.4

# Checkout the correct branch of Raspberry Pi Linux fork.
cd ../rpi-linux
git checkout rpi-6.12.y

# Checkout the correct branch of BusyBox.
cd ../busybox
git checkout 1_36_1
