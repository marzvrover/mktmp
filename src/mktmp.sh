#!/bin/sh

function guardDependencies {
    hasDependencies=true

    # check which is installed
    if ! command -v which &> /dev/null
    then
        >&2 echo "which is not installed. Please install it."
        $hasDependencies=false
    fi

    # check if mktemp is installed
    if ! command -v mktemp &> /dev/null
    then
        >&2 echo "mktemp is not installed. Please install it."
        $hasDependencies=false
    fi

    # first check that tmpreaper is installed
    if ! command -v tmpreaper &> /dev/null
    then
        >&2 echo "tmpreaper is not installed. Please install it first."
        $hasDependencies=false
    fi

    # check if hasDependencies is false
    if [ $hasDependencies = false ]
    then
        exit 1
    fi
}

guardDependencies

LIFETIME=$1; shift # pop the lifetime argument
TMPDIR="/tmp/tmpreaper.$LIFETIME"

# guard against no arguments
if [ $# -eq 0 ]
then
    >&2 echo "No arguments supplied. Please supply a lifetime for the temporary file"
    exit 1
fi

# check that the $TMPDIR directory exists
if [ ! -d "$TMPDIR" ]
then
    mkdir -p "$TMPDIR"
fi

# set tmpreaper to run every minute using crontab
if ! crontab -l | grep -q "$TMPDIR"
then
    (crontab -l ; echo "* * * * * `which tmpreaper` $LIFETIME $TMPDIR") | crontab -
fi

# create a temporary file passing in the rest of the arguments
mktemp $@ "${TMPDIR}/XXXXXXXXXXXX"
