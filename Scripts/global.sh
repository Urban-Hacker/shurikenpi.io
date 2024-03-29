#!/bin/bash

enum ()
{
    # skip index ???
    shift
    AA=${@##*\{} # get string strip after { 
    AA=${AA%\}*} # get string strip before }
    AA=${AA//,/} # delete commaa  
    ((DEBUG)) && echo $AA
    local I=0
    for A in $AA ; do
        eval "$A=$I"
        ((I++))
    done
}

enum VERSION_TYPE { STABLE, DEV, DEV_DETACHED, NO_GIT };

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

shift "$((OPTIND-1))"

LOGS=/dev/null
INSTALLATION_FOLDER="$HOME/shurikenpi"
GIT_FOLDER="$HOME/shurikenpi/shurikenpi.io"
TMP_DIRECTORY=/tmp/shuriken_io
ARCHITECTURE=$(uname -m)

rm -fr $TMP_DIRECTORY 2>&1
mkdir $TMP_DIRECTORY 2>&1

GIT_URL=https://github.com/Urban-Hacker/shurikenpi.io/

if command -v screen >/dev/null 2>&1; then
    SESSION_COUNT=$(screen -ls | grep -c "\.shurikenpi.io")
else
    SESSION_COUNT=0
fi

extract_version(){
    INSTALLED_VERSION=""
    INSTALLED_TYPE=""
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        INSTALLED_VERSION="NO GIT"
        INSTALLED_TYPE=$NO_GIT
        return 0
    fi
    local branch=$(git rev-parse --abbrev-ref HEAD)
    local tag=$(git describe --tags --abbrev=0 2>/dev/null)
    local commit_hash=$(git rev-parse HEAD)
    local commit_hash=${commit_hash:0:5}

    if [[ "$branch" == "HEAD" ]]; then
        INSTALLED_VERSION="$commit_hash (dev)"
        INSTALLED_TYPE=$DEV_DETACHED
    else
        if [[ "$branch" == "stable" && -n "$tag" ]]; then
            INSTALLED_VERSION="$tag"
            INSTALLED_TYPE=$STABLE
        else
            INSTALLED_VERSION="$commit_hash (dev)"
            INSTALLED_TYPE=$DEV
        fi
    fi
}

extract_version