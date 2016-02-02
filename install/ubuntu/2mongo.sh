sudo cp ../mongod.setup.conf /etc/mongod.conf
sudo service mongod restart
sleep 1
mongo -port 27081 admin mongo1.js
mongo -port 27081 feel  mongo2.js
sudo cp ../mongod.conf /etc/
sudo service mongod restart
sleep 1
