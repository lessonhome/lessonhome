

module.exports = function(lib){
  require ('coffee-script/register');
  require ('coffee-cache');


  var Command = require(lib + '/feel/command');
  var command = new Command();
  //command.init().then(command.run).done();
  command.run();
}


