#!/bin/bash

#
# unittest - Simple, single-header, C/C++ unit-test framework.
# Copyright (C) 2024 Nicolas Sauzede (nicolas.sauzede@gmail.com)
# SPDX-License-Identifier: GPL-3.0-or-later
#

# Regular expression of file names monitored for changes
# Ignore file names containing `#` (eg: MC temp files starting with `.#`)
RE='\(MODIFY\|CREATE\) [^#]*\.\(py\)$'
# Actual test script to run on changes
TEST=./tfast.sh

red="\x1b[0;31m"
bred="\x1b[1;31m"
green="\x1b[0;32m"
bgreen="\x1b[1;32m"
yellow="\x1b[0;33m"
byellow="\x1b[1;33m"
blue="\x1b[1;34m"
bwhite="\x1b[1;37m"
nrm="\x1b[0m"
step=0
function separator {
    printf "\n\n\n\n\n\n\n\n"
}
function tdd_status {
    if [ "$1" = "0" ]; then
        printf "\n${bgreen}[=> SUCCESS <=]${nrm}"
    else
        printf "\n${bred}[=> FAILURE <=]${nrm}"
    fi
    printf " ${bwhite}<----- Proceed with TDD cycle..${nrm} "\
"(${bred}Red${nrm}, ${bgreen}Green${nrm}, ${byellow}Refactor${nrm}) #${step}\n"
    ((step=$step+1))
}
function change_detected {
    printf "${bwhite}---------------------> "\
"Re{build|test}ing..${nrm} [$1]\n\n"
}
function do_test {
    separator
    change_detected "$1"
    ${TEST}
    ret=$?
    tdd_status $ret
    return $ret
}

if [ -z "$(which inotifywait)" ]; then
    echo "Requirement: install `inotify-tools`"
    exit 1
fi
do_test "<Initial step>"
################################################################################
inotifywait -q --recursive --monitor --format "%e %w%f" \
--event modify,move,create,delete ./ \
| while read changed; do
    echo "$changed" | grep "$RE" 2>&1 > /dev/null || continue
    do_test "$changed"
done
