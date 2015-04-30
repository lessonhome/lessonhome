
// входной js скрипт для подключения coffee при форке потока

require('coffee-script/register');
require('coffee-cache').setCacheDir('.cache/.coffee');
var Lib = new (require('../lib'))();

Lib.init().then(function(){
  var SlaveProcess = require('./slaveProcessFork.coffee');
  var slaveProcess = new SlaveProcess();
  global.Main = slaveProcess;
  return slaveProcess.init();
}).done();




