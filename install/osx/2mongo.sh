sudo cp ../mongod.setup.conf /usr/local/etc/mongod.conf
brew services restart mongo
sleep 1
mongo -port 27081 admin mongo1.js
mongo -port 27081 feel  mongo2.js
sudo cp ../mongod.conf /etc/
brew services restart mongo
sleep 1
