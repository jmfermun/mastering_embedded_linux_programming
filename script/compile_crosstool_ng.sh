#!/bin/bash

cd "$(dirname "$0")"/../crosstool-ng

./bootstrap
./configure --prefix=${PWD}
make
make install
