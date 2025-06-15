#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Change to the example directory.
cd "$(dirname "$0")"

# Add compiler environment variables.
source ../../melp/Chapter02/set-path-arm-cortex_a8-linux-gnueabihf

echo "# Clean."
rm -f test1.o test2.o libtest.a libtest.so helloworld helloworld-static

echo "# Static library creation."
arm-cortex_a8-linux-gnueabihf-gcc -c test1.c
arm-cortex_a8-linux-gnueabihf-gcc -c test2.c
arm-cortex_a8-linux-gnueabihf-ar rc libtest.a test1.o test2.o

echo "# Static library linking."
arm-cortex_a8-linux-gnueabihf-gcc helloworld.c -ltest -L. -o helloworld-static
../../melp/list-libs helloworld-static

echo "# Dinamyc library creation."
arm-cortex_a8-linux-gnueabihf-gcc -fPIC -c test1.c
arm-cortex_a8-linux-gnueabihf-gcc -fPIC -c test2.c
arm-cortex_a8-linux-gnueabihf-gcc -shared -o libtest.so test1.o test2.o

echo "# Dynamic library linking."
arm-cortex_a8-linux-gnueabihf-gcc helloworld.c -ltest -L. -o helloworld
../../melp/list-libs helloworld

echo "# Check generated files."
ls -l
