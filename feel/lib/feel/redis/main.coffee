
_Redis = require 'redis'


class Redis
  constructor : ->
    $W @
  get : =>
    if _production
      redis =  _Redis.createClient {port : 36379,return_buffers: false}
      yield _invoke redis, 'auth',"Savitri2734&"
    else
      redis = _Redis.createClient {return_buffers:false}
    return redis




module.exports = Redis


