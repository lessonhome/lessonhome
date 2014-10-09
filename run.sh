#!/bin/bash
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$ROOT"

killall -KILL node 2>> /dev/null
mkdir -p log
node ./feel/bin/feel --harmony --force 
#> log/out.log 2>> log/out.log &
