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

tokens=$(ctags -x --c++-kinds=$flags --language-force=c++ --extra=q "$ifile" \
    | ~/.fk/ctags.awk)         #                                        ^
                               # Quote to deal with path having spaces _|
if [ -n "$tokens" ];then
    echo "$ifile:" >> $ofile
    echo "$tokens" >> $ofile
    echo >> $ofile
fi

