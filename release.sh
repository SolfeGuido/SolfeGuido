#!/bin/bash

WD=`pwd`
TEMP=`mktemp -d` # create a temporary directory
# Do some cleanup
rm -rf $WD/../solfege-release

cp -R * $TEMP
cd $TEMP
rm -rf examples
rm -rf spec
rm -rf .git
rm -rf .vscode
sed -i -e '/--- BEGIN DEBUG/,/--- END DEBUG/d' main.lua
rm lib/debugGraph.lua
rm lib/lurker.lua

compile() {
    cd $TEMP # move to temp
    for file in $(find . -iname "*.lua") ; do # for each lua file recursively
        if [ "$file" != "./conf.lua" ]; then
            luajit -b ${file} ${file} # compile the code with luajit onto itself
        fi
    done
}

#compile

rm release.sh
# Make the releases
love-release -W32 -W64 -D -M $WD/../solfege-release $TMP

rm -rf $TEMP # cleanup