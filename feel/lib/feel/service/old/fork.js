

require('coffee-script/register');
require('coffee-cache').setCacheDir('.cache/.coffee');

var Fork = require('./fork.coffee');
var fork = new Fork();
fork.init();




