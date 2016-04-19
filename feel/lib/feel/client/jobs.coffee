


class @Jobs
  constructor : ->
    $W @
    @ee = new EE
    @signals = new EE
    @solves = {}
    @listening = {}
    @data = {}
  init    : =>
  solve   : (name,data...)=>
    d = Q.defer()
    id = _randomHash()
    @solves[id] = (obj)=>
      if obj.err
        d.reject obj.err
      else
        d.resolve obj.data
      delete @solves[id]
    @ee.once id,@onMessage
    @data["jobs:"+name] ?= []
    @data["jobs:"+name].unshift {
      id : id
      name : "jobs:"+name
      data : data
    }
    @ee.emit 'jobs:'+name,'jobs:'+name,''
    return d.promise
  signal    : => @signals.emit arguments...
  onSignal  : => @signals.on arguments...
  onMessage : (channel,m)=> Q.spawn =>
    if m && @solves[channel]
      @solves[channel] m
      return
    while true
      return unless @data[channel]?
      m = @data[channel].pop()
      delete @data[channel] if @data[channel].length == 0
      return unless m
      do (m)=> Q.spawn =>
        obj = m
        [job_type,name] = obj.name.split ':'
        try
          switch job_type
            when 'jobs'
              foo = @listening[name][Math.floor(Math.random()*@listening[name].length)]
              ret = yield foo obj.data...
            else throw new Error 'wrong job_type(jobs) but '+job_type
          @ee.emit obj.id, obj.id,{data:ret}
        catch err
          console.error err
          @ee.emit obj.id, obj.id,{err:err}
      yield Q.delay 0
  listen  : (name,foo)=>
    unless @listening[name]?
      @listening[name] = []
      @ee.on 'jobs:'+name,@onMessage
    @listening[name].push foo
    @ee.emit 'jobs:'+name,'jobs:'+name,''

  server  : (jobName,data...)=>
    {ret,error} = yield Feel.send "workers/jobs","./io_client",jobName,data...,'quiet'
    throw ExceptionUnJson error if error
    return ret






