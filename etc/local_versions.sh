#!/bin/bash

function versioninfo {
    cd $1
    if [ -e bower.json ]
    then
        echo $1 $(cat README.md | grep -i --after-context 2 "platform version" | tail -1 ) $(git rev-parse HEAD)
    elif [ -e package.json ]
    then
        echo $1 $(sed -nE 's/^\s*"version": "(.*?)",$/\1/p' package.json) $(git rev-parse HEAD)
    elif [ -e DESCRIPTION ]
    then
        echo $1 $(sed -n '/Version:/p' DESCRIPTION | sed 's/[^0-9,.]*//g') $(git rev-parse HEAD)
    else
        echo $1 $(git rev-parse HEAD)
    fi
    cd ..
}

for dir in $(ls -1d */ | grep -v 'etc')
do
  versioninfo ${dir}
done

echo ". (reference-implementation)" $(git rev-parse HEAD)
