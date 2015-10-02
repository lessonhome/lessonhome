
_Redis = require 'redis'

class Redis
  constructor : ->
    $W @
  init : =>
    @redis = _Redis.createClient()
  close : =>
  get : => @redis



module.exports = Redis


