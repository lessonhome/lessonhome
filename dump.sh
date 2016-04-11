#!/bin/bash
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$ROOT"

SSH="ssh -p 32322 -oStrictHostKeyChecking=no -l dump"
mkdir -p www/lessonhome/static/user_data
rm -rf www/lessonhome/static/temp
rsync -azv --delete -e "$SSH" lessonhome.org:~/data/latest/images ./www/lessonhome/static/user_data
rsync -azv --delete -e "$SSH" lessonhome.org:~/data/latest/urldata ./www/lessonhome/static/
mkdir -p .cache
rsync -azv --delete -e "$SSH" lessonhome.org:~/data/latest/mongo .cache/
./mongo.sh mongoremove.js
mongorestore --username admin --password 'Monach2734&' --host 127.0.0.1:27081 .cache/mongo

cp ./www/lessonhome/static/urldata/pi0h.org.json ./www/lessonhome/static/urldata/`hostname`.json
touch ./www/lessonhome/static/urldata/.gitkeep
./mongo.sh dbindexing.js
