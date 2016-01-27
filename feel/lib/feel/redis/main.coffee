
_Redis = require 'redis'
_Redlock = require 'redlock'

os = require 'os'
hostname = os.hostname()

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
    if _production
      redis =  _Redis.createClient port : 36379
      yield _invoke redis, 'auth',"Savitri2734&"
    else
      redis = _Redis.createClient()
    return redis
  getLock : =>
    @connect()
    return @redlock




module.exports = Redis


