#!/bin/bash
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$ROOT"


#if [ "$#" -eq 1 ];then
#  cd feel
#  npm i
#  cd ..
#fi

killall -KILL node 2>> /dev/null
node --harmony ./feel/bin/feel & 
#node ./feel/bin/updater --harmony --force & 

#> log/out.log 2>> log/out.log &
