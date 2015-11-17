
_Redis = require 'redis'

class Redis
  constructor : ->
    $W @
  init : =>
  close : =>
  get : =>
    @redis ?= _Redis.createClient()
    return @redis



module.exports = Redis


