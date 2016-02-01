

require('coffee-script/register');
require('coffee-cache').setCacheDir('.coffee_cache');

var Fork = require('./fork.coffee');
var fork = new Fork();
fork.init();




