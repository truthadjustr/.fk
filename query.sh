#!/bin/bash
#

[ $# -lt 2 ] && exit 1

ifile=$PWD/${1#"./"}
flags=$2

ofile=${3:-/dev/stdout}

# Avoid un-initialized bash string concatination.
# It can cause exported $line from your shell
# to creep-in into your script!
# line="$line "$c

tokens=($(ctags -x --c++-kinds=$flags --language-force=c++ --extra=q "$ifile" \
    | ~/.fk/ctags.awk -v a=1)) #                                        ^
                               # Quote to deal with path having spaces _|
if((${#tokens[@]} > 0));then
    # got some weird extra 0x20 hex with printf
    #printf "%s %s " $ifile ${tokens[@]} >> $ofile
    #printf "\n" >> $ofile
    echo "$ifile ${tokens[@]}" >> $ofile
fi

