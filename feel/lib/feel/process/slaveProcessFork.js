
// входной js скрипт для подключения coffee при форке потока
/*
var heapdump = require('heapdump');
var conf = JSON.parse(process.env.FORK);
heapdump.writeSnapshot('heap/'+conf.processId+'.heapsnapshot');
*/
require('coffee-script/register');
require('coffee-cache').setCacheDir('.coffee_cache');
var Lib = new (require('../lib'))();

Lib.init().then(function(){
  var SlaveProcess = require('./slaveProcessFork.coffee');
  var slaveProcess = new SlaveProcess();
  global.Main = slaveProcess;
  return slaveProcess.init();
}).done();




