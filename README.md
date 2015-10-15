**Как развернуть проект**

Ubuntu vivid:

```Shell
sudo sh -c 'echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" > /etc/apt/sources.list.d/mongodb.list'
sudo sh -c 'echo "deb http://ppa.launchpad.net/chris-lea/redis-server/ubuntu vivid main" > /etc/apt/sources.list.d/redis.list'

sudo apt-get update

## **ТОЛЬКО ДЛЯ ubuntu vivid**
sudo apt-get install upstart-sysv # нужно для работы mongodb под upstart (требует перезагрузки)
## 

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
cd ~/lessonhome/
./mongo.sh ./dbindexing.js
```

**Запуск проекта:**

если из консоли:
```Shell
cd ~/lessonhome/
./run.sh
# чтобы остановить скрипт ./kill.sh
# чтобы запустить в phpstorm надо сначала остановить в консоле
```

если из phpstorm
создавать новый проект, указывать папку ~/lessonhome, подтверждать создание проекта из существующих файлов
надо поставить плагин для node.js и jade
добавить конфигурацию запуска node.js 
прогу указывать /usr/bin/iojs
путь к скрипту feel/bin/feel
так же в настройках для редакторов указывать дефолтные отступы на таб 2 пробела, а не 4 или 8
когда он говорит откомпилить sass/jade/coffeescipt или нет, жмем dissmiss(вроде так)

Чтобы отчистить кеш надо удалить папки ~/lessonhome/feel/.sass-cahce и ~/lessonhome/.cache

**В браузере**

по умолчанию доступно по ссылке 127.0.0.1:8081/
можно заюзать скрипт  sudo ~/lessonhome/iptables.sh
и добавить его в /etc/rc.local перед exit
sudo /home/**USER**/lessonhome/iptables.sh
