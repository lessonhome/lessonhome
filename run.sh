#!/bin/bash
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$ROOT"

./kill.sh

export NODE_ENV=production

#killall iojs 2>> /dev/null
#killall node 2>> /dev/null
#killall nodejs 2>> /dev/null
#killall -KILL iojs 2>> /dev/null
#killall -KILL node 2>> /dev/null
#killall -KILL nodejs 2>> /dev/null
#echo "" > nohup.out
#if [ "$#" -eq 1 ];then

node --es_staging --harmony --harmony_object_observe --harmony_modules --harmony_function_sent --harmony_sharedarraybuffer --harmony_simd --harmony_do_expressions --harmony_iterator_close --harmony_tailcalls  --harmony_object_values_entries --harmony_object_own_property_descriptors --harmony_regexp_property ./feel/bin/feel --color &

#  node --harmony_proxies ./feel/bin/feel  --color &
#  nohup node ./feel/bin/feel --color  >> ./nohup.out 2>> ./nohup.out &
#else
#  node --harmony_proxies ./feel/bin/feel  --color &
  #nohup node  ./feel/bin/feel --color >> ./nohup.out 2>> ./nohup.out &
#fi
#tail -f ./nohup.out &
#node ./feel/bin/updater --harmony --force & 

#> log/out.log 2>> log/out.log &
