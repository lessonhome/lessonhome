
_Redis = require 'redis'
_Redlock = require 'redlock'

class Redis
  constructor : ->
    $W @
  init : =>
  close : =>
  connect : =>
    @redlock ?= new _Redlock [@redis],{
      driftFactor: 0.01,
      retryCount:  3,
      retryDelay:  200
    }
  get : =>
    return  _Redis.createClient()
  getLock : =>
    @connect()
    return @redlock




module.exports = Redis


