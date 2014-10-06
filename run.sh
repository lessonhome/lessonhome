#!/bin/bash
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$ROOT"

killall -KILL node
mkdir -p log
node ./feel/bin/feel --harmony --force > log/out.log 2>> log/out.log &
tail -f log/out.log
