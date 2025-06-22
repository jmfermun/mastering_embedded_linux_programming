#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Change to respository root directory.
cd "$(dirname "$0")"/..

# Add submodules.
git submodule add https://github.com/PacktPublishing/Mastering-Embedded-Linux-Programming-Third-Edition.git melp
git submodule add https://github.com/crosstool-ng/crosstool-ng.git crosstool-ng
git submodule add https://source.denx.de/u-boot/u-boot.git u-boot
