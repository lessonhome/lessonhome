**Как развернуть проект**

Ubuntu vivid:

```Shell
sudo sh -c 'echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" > /etc/apt/sources.list.d/mongodb.list'
sudo sh -c 'echo "deb http://ppa.launchpad.net/chris-lea/redis-server/ubuntu vivid main" > /etc/apt/sources.list.d/redis.list'

sudo apt-get update

sudo apt-get install upstart-sysv # нужно для работы mongodb под upstart (требует перезагрузки)

sudo apt-get install git git-core ruby2.1 ruby2.1-dev ruby2.1-tcltk imagemagick redis memcached default-jre
sudo gem update
sudo gem update --system
git clone https://github.com/lessonhome/lessonhome.git ~/lessonhome/

wget https://iojs.org/dist/v3.3.1/iojs-v3.3.1-linux-x64.tar.gz
tar xf iojs-v3.3.1-linux-x64.tar.gz
cd iojs-v3.3.1-linux-x64
sudo cp -R bin include lib share /usr/
cd ~/lessonhome/feel
npm i
cd
sudo gem install compass
```
После перезагрузки
```Shell
cd ~/lessonhome/install/ubuntu
./1mongo.sh # установка mongodb
```
Ждем пока он напишет слушаю порт, затем Ctrl+C и

```Shell
cd ~/lessonhome/install/ubuntu
./2mongo.sh # настройка mongodb
```
