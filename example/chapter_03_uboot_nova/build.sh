#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Change to the example directory.
cd "$(dirname "$0")"

# Add compiler environment variables.
source ../../melp/Chapter02/set-path-arm-cortex_a8-linux-gnueabihf

# Change to u-boot directory
cd ../../u-boot

# To update the patch file, stage the changes and execute:
# git diff --staged > ../example/chapter_03_uboot_nova/nova_patch.patch

echo "# Apply patch to U-Boot for nova board."
git apply ../example/chapter_03_uboot_nova/nova_patch.patch

echo "# Build U-Boot for nova board."
make distclean
make nova_defconfig
make
