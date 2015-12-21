
_kue = require 'kue'

class Jobs
  constructor : ->
    $W @
    @listening = {}
  init : =>
    yield @connect()
  connect : =>
    return if @queue?
    @queue    = _kue.createQueue()
    @solves   = {}
    @queue.on 'error',(err)->
      console.error err
    yield @redisConnect()
    #_kue.app.listen 5555
    #@queue.watchStuckJobs 10000
    ###
    @queue.active (err,ids)->
      ids.forEach (id)->
        _kue.Job.get id, (err,job)-> job.inactive() unless err
    ###
    _kue.Job.rangeByState 'complite', 0, 10000000, 'asc', (err, jobs)->
      jobs.forEach ( job )-> job.remove()
    _kue.Job.rangeByState 'failed', 0, 10000000, 'asc', (err, jobs)->
      jobs.forEach ( job )-> job.remove()
  redisConnect : =>
    @redis = yield Main.service 'redis'
    @redisP = yield @redis.get()
    @redisS = yield @redis.get()
    @redisS.on 'subscribe',=> @onSubscribe.apply @,arguments
    @redisS.on 'message',  => @onMessage.apply @,arguments
  onSubscribe : (name)=> Q.spawn =>
    ###
    yield _invoke @redisP,'lpush','jobs:email:',JSON.stringify {
      name : 'jobs:email:'
      id : 'qweop'
      data : {to:'tema.dudko'}
    }
    @redisP.publish "jobs:email:",""
    ###
  onMessage   : (channel,m)=> Q.spawn =>
    if m && @solves[channel]
      @solves[channel] JSON.parse m
      return
    while true
      m = yield _invoke @redisP,'rpop',channel
      return unless m
      do (m)=> Q.spawn =>
        obj = JSON.parse m
        [temp,name,hash] = obj.name.split ':'
        try
          ret = yield @listening[name].hash[hash] obj.data
          @redisP.publish obj.id,JSON.stringify {data:ret}
        catch err
          console.error err
          @redisP.publish obj.id,JSON.stringify {err:err}
      yield Q.delay 0
  listen2 : (name,hash='',foo)=>
    yield @connect()
    unless foo
      foo = hash
      hash = ''
    name2 = name+':'+hash
    unless @listening[name]?
      @listening[name] = hash:{}
    unless @listening[name].hash[hash]==foo
      unless @listening[name].hash[hash]
        @queue.process name2,2,(job,done)=>
          @onprocess.call @,job,done
          return
      @listening[name].hash[hash] = foo
  listen : (name,hash='',foo)=>
    yield @connect()
    unless foo
      foo = hash
      hash = ''
    name2 = name+':'+hash
    unless @listening[name]?
      @listening[name] = hash:{}
    unless @listening[name].hash[hash]==foo
      unless @listening[name].hash[hash]
        yield _invoke @redisS,'subscribe', 'jobs:'+name2
        #@queue.process name2,2,(job,done)=>
        #  @onprocess.call @,job,done
        #  return
      @listening[name].hash[hash] = foo
      yield @onMessage 'jobs:'+name2
  onprocess : (job,done)=> Q.spawn =>
    [name,hash] = job.type.split(':')
    ret = yield @listening[name].hash[hash] job.data
    done null,ret
    return
  solve2  : (name,data,priority)=>
    yield @connect()
    d = Q.defer()
    hash = data.hash || ''
    name2 = name+':'+hash
    job = @queue.create name2,data
    job = job.ttl 1000000
    job = job.attempts(3).backoff( true ).removeOnComplete(true)
    job = job.priority(priority) if priority
    job = job.on 'complete',(res)=>
      d.resolve res
    job = job.on 'failed',(err)=>
      d.reject err
    job = job.save()
    return d.promise
  solve : (name,hash="",data)=>
    yield @connect()
    unless data
      data = hash
      hash = ""
    d = Q.defer()
    hash = data.hash || ''
    name2 = name+':'+hash
    id = _randomHash()
    @solves[id] = (obj)=>
      if obj.err
        d.reject obj.err
      else
        d.resolve obj.data
        delete @solves[id]
      @redisS.unsubscribe id
    yield _invoke @redisS,'subscribe',id
    yield _invoke @redisP,'lpush',"jobs:"+name2, JSON.stringify {
      id    : id
      name  : "jobs:"+name2
      data  : data
    }
    @redisP.publish "jobs:"+name2,''
    ###
    job = @queue.create name2,data
    job = job.ttl 1000000
    job = job.attempts(3).backoff( true ).removeOnComplete(true)
    job = job.priority(priority) if priority
    job = job.on 'complete',(res)=>
      d.resolve res
    job = job.on 'failed',(err)=>
      d.reject err
    job = job.save()
    ###
    return d.promise

module.exports = Jobs
