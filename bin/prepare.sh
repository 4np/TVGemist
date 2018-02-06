#!/usr/bin/env bash

dir=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
me=${0##*/}

FILES=$dir/*.sh
for f in $FILES
do
    if [ $f != "$dir/$me" ]; then
        echo $f
        time source $f
    fi
done

