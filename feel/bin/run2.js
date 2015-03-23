

module.exports = function(lib){
  require ('coffee-script/register');
  require ('coffee-cache').setCacheDir('.cache/.coffee');


  var Command = require(lib + '/feel/command2');
  var command = new Command();
  command.init().then(command.run).done();
}


