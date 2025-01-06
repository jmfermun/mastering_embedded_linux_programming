#!/bin/bash

cd "$(dirname "$0")"/..

# Initialize the repository submodules.
git submodule update --init --force --remote
