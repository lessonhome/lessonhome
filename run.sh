

#!/bin/bash
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$ROOT"

./kill.sh

#killall iojs 2>> /dev/null
#killall node 2>> /dev/null
#killall nodejs 2>> /dev/null
#killall -KILL iojs 2>> /dev/null
#killall -KILL node 2>> /dev/null
#killall -KILL nodejs 2>> /dev/null
echo "" > nohup.out
if [ "$#" -eq 1 ];then
  nohup iojs ./feel/bin/feel  >> ./nohup.out 2>> ./nohup.out &
else
  nohup iojs  ./feel/bin/feel >> ./nohup.out 2>> ./nohup.out &
fi
tail -f ./nohup.out &
#node ./feel/bin/updater --harmony --force & 

#> log/out.log 2>> log/out.log &


# ПУК
