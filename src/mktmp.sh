#!/bin/sh

guardDependencies () {
    hasDependencies=true

    # ensure which is installed
    if ! command -v which > /dev/null 2>&1
    then
        >&2 echo "which is not installed. Please install it."
        hasDependencies=false
    fi

    # ensure mktemp is installed
    if ! command -v mktemp > /dev/null 2>&1
    then
        >&2 echo "mktemp is not installed. Please install it."
        hasDependencies=false
    fi

    # ensure crontab is installed
    if ! command -v crontab > /dev/null 2>&1
    then
        >&2 echo "crontab is not installed. Please install it."
        hasDependencies=false
    fi

    # ensure tmpreaper is installed
    if ! command -v tmpreaper > /dev/null 2>&1
    then
        >&2 echo "tmpreaper is not installed. Please install it."
        hasDependencies=false
    fi

    # ensure no dependencies are missing
    if [ $hasDependencies = false ]
    then
        exit 1
    fi
}

guardDependencies

# guard against no arguments
if [ $# -eq 0 ]
then
    >&2 echo "No arguments supplied. Please supply a lifetime for the temporary file"
    exit 1
fi

LIFETIME=$1; shift # pop the lifetime argument
TMPDIR="/tmp/tmpreaper.$LIFETIME"

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
