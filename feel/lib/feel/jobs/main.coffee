

class Jobs
  constructor : ->
    $W @
    @listening  = {}
    @solves     = {}
  init : =>
    @redis = yield Main.service 'redis'
    @redisP = yield @redis.get()
    @redisS = yield @redis.get()
    @redisS.on 'message',  => @onMessage.apply @,arguments
  onMessage   : (channel,m)=> Q.spawn =>
    if m && @solves[channel]
      @solves[channel] JSON.parse m
      return
    while true
      m = yield _invoke @redisP,'rpop',channel
      return unless m
      do (m)=> Q.spawn =>
        obj = JSON.parse m
        [temp,name] = obj.name.split ':'
        try
          ret = yield @listening[name].foo obj.data...
          @redisP.publish obj.id,JSON.stringify {data:ret}
        catch err
          console.error err
          @redisP.publish obj.id,JSON.stringify {err:err}
      yield Q.delay 0
  listen : (name,foo)=>
    unless @listening[name]?
      @listening[name] = {}
    unless @listening[name].foo?
      yield _invoke @redisS,'subscribe', 'jobs:'+name
    @listening[name].foo = foo
    yield @onMessage 'jobs:'+name
  solve : (name,data...)=>
    d = Q.defer()
    id = _randomHash()
    @solves[id] = (obj)=>
      if obj.err
        d.reject obj.err
      else
        d.resolve obj.data
        delete @solves[id]
      @redisS.unsubscribe id
    yield _invoke @redisS,'subscribe',id
    yield _invoke @redisP,'lpush',"jobs:"+name, JSON.stringify {
      id    : id
      name  : "jobs:"+name
      data  : data
    }
    @redisP.publish "jobs:"+name,''
    return d.promise

module.exports = Jobs
