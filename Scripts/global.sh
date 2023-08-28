#!/bin/bash

VERBOSE=0
while getopts ":v" option; do
    case "${option}" in
        v)
            VERBOSE=1
            ;;
        *)
            echo "Usage: $0 [-v]"
            exit 1
            ;;
    esac
done

LOGS=/dev/null
INSTALLATION_FOLDER="$HOME/shurikenpi"
GIT_FOLDER="$HOME/shurikenpi/shurikenpi.io"
TMP_DIRECTORY=/tmp/shuriken_io

rm -fr $TMP_DIRECTORY 2>&1
mkdir $TMP_DIRECTORY 2>&1

GIT_URL=https://github.com/Urban-Hacker/shurikenpi.io/