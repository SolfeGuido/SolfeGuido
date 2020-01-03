#!/bin/bash

WD=`pwd`
TEMP=`mktemp -d` # create a temporary directory
RELEASE=$WD/../solfege-release
# Do some cleanup
rm -rf $RELEASE

cp -R * $TEMP
cd $TEMP
rm -rf examples
rm -rf spec
rm -rf .git
rm -rf .travis.yml
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
love-release -W32 -W64 -D -M $RELEASE $TMP

rm -rf $TEMP # cleanup

# Release for android
rm -rf ${SOLFEGUIDO_ANDROID}/game.love
cp $RELEASE/SolfeGuido.love ${SOLFEGUIDO_ANDROID}/game.love