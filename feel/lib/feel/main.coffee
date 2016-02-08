

MasterProcessManager = require './process/masterProcessManager'
MasterServiceManager = require './service/masterServiceManager'

class Main
  constructor : ->
    $W @
    @name = 'Master'
    @startTime = new Date()
    setInterval =>
      t = new Date()-@startTime
      sec = 1000
      min = sec*60
      hour = min*60
      console.log "started time 
        #{Math.floor(t/hour)}:#{Math.floor((t/min)%60)}:#{Math.floor((t/sec)%60)}".grey
    , 5*60*1000
  init : =>
    @redis = yield _Helper('redis/main').get()
    yield @removeCacheByRestart()
    yield @removeCacheByVersion() unless yield @version()
    
    yield Q.all [
      _mkdirp '.cache'
      _mkdirp '.coffee_cache'
    ]
    
    @serviceManager = new MasterServiceManager()
    @processManager = new MasterProcessManager()
    yield @serviceManager.init?()
    yield @processManager.init?()
    unless @feel_version_now == @feel_version_old
      yield _invoke @redis,'set','feel-version',@feel_version_now
    yield @serviceManager.run?()
    yield @processManager.run?()
  removeCacheByVersion : =>
    redis_keys = ['__masterProcessConfig','module_cache','state_cache','client_cache']
    yield Q.all [
      _invoke @redis,'del',redis_keys
      _rmrf '.cache'
      _rmrf 'feel/.sass-cache'
    ]
  removeCacheByRestart : =>
    redis_keys = ['client_jobs:*','jobs:*']
    qs = for key in redis_keys then _invoke @redis,'keys',key
    qs = yield Q.all qs
    keys = []
    keys.push arr... for arr in qs
    yield _invoke @redis,'del',keys if keys?[0]
    
  version : =>
    [now,old] = yield Q.all [
      _readFile 'feel/version'
      _invoke @redis,'get','feel-version'
    ]
    now ?= ""
    old ?= ""
    now = now.toString()
    @feel_version_now = now.replace(/\D/gmi,'')
    @feel_version_old = old.replace(/\D/gmi,'')
    yield _invoke @redis,'set','feel-version-now',@feel_version_now
    return @feel_version_now==@feel_version_old


module.exports = Main

