#!/bin/bash
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$ROOT"

telegram-cli -c ./conf -k pub -I  -N -C --json  --exec "$1"
