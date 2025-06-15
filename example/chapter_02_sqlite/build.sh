#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Change to the example directory.
cd "$(dirname "$0")"

# Add compiler environment variables.
source ../../melp/Chapter02/set-path-arm-cortex_a8-linux-gnueabihf

echo "# Clean."
rm -rf sqlite-autoconf-3500100.tar.gz sqlite-autoconf-3500100

echo "# Get SQLite source code."
wget https://www.sqlite.org/2025/sqlite-autoconf-3500100.tar.gz
tar xf sqlite-autoconf-3500100.tar.gz
cd sqlite-autoconf-3500100

echo "# Compile and install SQLite."
export CC=arm-cortex_a8-linux-gnueabihf-gcc
./configure --host=arm-cortex_a8-linux-gnueabihf --prefix=/usr
make
export SYSROOT=$(arm-cortex_a8-linux-gnueabihf-gcc -print-sysroot)
make DESTDIR=$SYSROOT install

echo "# Check installed files."
ls -la $SYSROOT/usr/bin | grep sqlite3
ls -la $SYSROOT/usr/lib | grep sqlite3
ls -la $SYSROOT/usr/lib/pkgconfig | grep sqlite3
ls -la $SYSROOT/usr/include | grep sqlite3
ls -la $SYSROOT/usr/share/man/man1 | grep sqlite3

echo "# Package information."
cat $SYSROOT/usr/lib/pkgconfig/sqlite3.pc
export PKG_CONFIG_LIBDIR=$SYSROOT/usr/lib/pkgconfig
pkg-config sqlite3 --libs --cflags
