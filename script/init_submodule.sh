#!/bin/bash

cd "$(dirname "$0")"/..

# Initialize the repository submodules.
git submodule update --init --force --remote

# Checkout the correct release of crosstool-NG.
cd crosstool-ng
git checkout crosstool-ng-1.26.0

# Checkout the correct branch of Mastering Embedded Linux Programming Third Edition.
cd ../melp
git checkout master

# Decompress x-tools. To compress the folder use "tar -czvf x-tools.tar.gz x-tools".
cd ..
tar -xzvf x-tools.tar.gz
