#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Change to the example directory.
cd "$(dirname "$0")"

# Add compiler environment variables.
source ../../melp/Chapter02/set-path-arm-cortex_a8-linux-gnueabihf
export SYSROOT=$(arm-cortex_a8-linux-gnueabihf-gcc -print-sysroot)

echo "# Dinamyc libc linking."
arm-cortex_a8-linux-gnueabihf-gcc helloworld.c -o helloworld
file helloworld
../../melp/list-libs helloworld

echo "# Static libc linking."
arm-cortex_a8-linux-gnueabihf-gcc -static helloworld.c -o helloworld-static
file helloworld-static
../../melp/list-libs helloworld-static

echo "# Check generated files."
ls -l
ls -l $SYSROOT/usr/lib/libc.a
