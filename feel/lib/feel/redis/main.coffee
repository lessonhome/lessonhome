
_Redis = require 'redis'


class Redis
  constructor : ->
    $W @
  get : =>
    if _production
      redis =  _Redis.createClient port : 36379
      yield _invoke redis, 'auth',"Savitri2734&"
    else
      redis = _Redis.createClient()
    return redis




module.exports = Redis


