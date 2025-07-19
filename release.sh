#!/bin/bash

set -euo pipefail

WD=$(pwd)

TEMP=$(mktemp -d)

cp -R * "$TEMP"
pushd $TEMP
TRASH=(Solfeguido.love examples spec .git .vscode lib/debugGraph.lua lib/lurker.lua lib/profile.lua)
for t in ${TRASH[*]}
do
    printf "Removing %s\n" $t
    rm -rf $t
done
sed -i -e '/--- BEGIN DEBUG/,/--- END DEBUG/d' main.lua


compile() {
    cd $TEMP
    for file in $(find . -iname "*.lua") ; do
        if [ "$file" != "./conf.lua" ]; then
            luajit -b ${file} ${file} # compile the code with luajit onto itself
        fi
    done
}

compile

rm release.sh

# Make the releases
zip -9 -r "$WD/Solfeguido.love" .

popd

rm -rf $TEMP # cleanup


cp "$WD/Solfeguido.love" ../AndroidApp/app/src/embed/assets/game.love
