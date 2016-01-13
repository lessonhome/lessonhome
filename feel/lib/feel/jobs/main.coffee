

class Jobs
  constructor : ->
    $W @
    @listening  = {}
    @solves     = {}
    @client_listening  = {}
    @client_solves     = {}
  init : =>
    @redis = yield Main.service 'redis'
    @redisP = yield @redis.get()
    @redisS = yield @redis.get()
    @redisS.on 'message',  => @onMessage.apply @,arguments
  onMessage   : (channel,m)=> Q.spawn =>
    if m
      if @solves[channel]
        @solves[channel] JSON.parse m
        return
      if @client_solves[channel]
        @client_solves[channel] JSON.parse m
        return
    while true
      m = yield _invoke @redisP,'rpop',channel
      return unless m
      do (m)=> Q.spawn =>
        obj = JSON.parse m
        [job_type,name] = obj.name.split ':'
        try
          switch job_type
            when 'jobs'         then ret = yield @listening[name].foo obj.data...
            when 'client_jobs'  then ret = yield @client_listening[name].foo obj.data...
            else throw new Error 'wrong job_type(jobs or client_jobs) but '+job_type
          @redisP.publish obj.id,JSON.stringify {data:ret}
        catch err
          console.error err
          @redisP.publish obj.id,JSON.stringify {err:ExceptionJson(err)}
      yield Q.delay 0
  listen : (name,foo)=>
    unless @listening[name]?
      @listening[name] = {}
    unless @listening[name].foo?
      yield _invoke @redisS,'subscribe', 'jobs:'+name
    @listening[name].foo = foo
    yield @onMessage 'jobs:'+name
  client : (name,foo)=>
    unless @client_listening[name]?
      @client_listening[name] = {}
    unless @client_listening[name].foo?
      yield _invoke @redisS,'subscribe', 'client_jobs:'+name
    @client_listening[name].foo = foo
    yield @onMessage 'client_jobs:'+name
  solve : (name,data...)=>
    d = Q.defer()
    id = _randomHash()
    @solves[id] = (obj)=>
      if obj.err
        d.reject ExceptionUnJson obj.err
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
  solve_as_client : (name,data...)=>
    d = Q.defer()
    id = _randomHash()
    @client_solves[id] = (obj)=>
      if obj.err
        d.reject ExceptionUnJson obj.err
      else
        d.resolve obj.data
        delete @client_solves[id]
      @redisS.unsubscribe id
    yield _invoke @redisS,'subscribe',id
    yield _invoke @redisP,'lpush',"client_jobs:"+name, JSON.stringify {
      id    : id
      name  : "client_jobs:"+name
      data  : data
    }
    @redisP.publish "client_jobs:"+name,''
    return d.promise
  

module.exports = Jobs
