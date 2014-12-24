

module.exports = function(lib){
  require ('coffee-script/register');
  require ('coffee-cache').setCacheDir('.cache/.coffee');


  var Command = require(lib + '/feel/command');
  var command = new Command();
  command.run();
}


