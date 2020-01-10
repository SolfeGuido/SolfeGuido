#!/bin/bash

WD=`pwd`
TEMP=`mktemp -d` # create a temporary directory
RELEASE=$WD/../solfege-release
# Do some cleanup
rm -rf $RELEASE

cp -R * $TEMP
cd $TEMP
TRASH=(examples spec .git .travis.yml .vscode lib/debugGraph.lua lib/lurker.lua lib/profile.lua)
for t in ${TRASH[*]}
do
    printf "Removing %s\n" $t
    rm -rf $t
done
sed -i -e '/--- BEGIN DEBUG/,/--- END DEBUG/d' main.lua


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