

#!/bin/bash
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$ROOT"



killall iojs 2>> /dev/null
killall node 2>> /dev/null
killall nodejs 2>> /dev/null
killall -KILL iojs 2>> /dev/null
killall -KILL node 2>> /dev/null
killall -KILL nodejs 2>> /dev/null

if [ "$#" -eq 1 ];then
  iojs ./feel/bin/feel &
else
  node --harmony ./feel/bin/feel &
fi
#node ./feel/bin/updater --harmony --force & 

#> log/out.log 2>> log/out.log &


# ПУК
