
_Memcached = require 'memcached'

class Memcached
  constructor : ->
    $W @
  init : =>
  close : =>
  get : =>
    @memcached ?= new _Memcached {'127.0.0.1:11211':1}
    return  @memcached



module.exports = Memcached


