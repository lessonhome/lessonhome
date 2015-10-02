
_Memcached = require 'memcached'

class Memcached
  constructor : ->
    $W @
  init : =>
    @memcached = new _Memcached {'127.0.0.1:11211':1}
  close : =>
  get : => @memcached



module.exports = Memcached


