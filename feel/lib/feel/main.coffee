

MasterProcessManager = require './process/masterProcessManager'
MasterServiceManager = require './service/masterServiceManager'

class Main
  constructor : ->
    @name = 'Master'
    @startTime = new Date()
    setInterval =>
      t = new Date()-@startTime
      sec = 1000
      min = sec*60
      hour = min*60
      console.log "started time 
        #{Math.floor(t/hour)}:#{Math.floor((t/min)%60)}:#{Math.floor((t/sec)%60)}".grey
    , 30000
    Wrap @
  init : =>
    @log()
    @serviceManager = new MasterServiceManager()
    @processManager = new MasterProcessManager()
    yield @serviceManager.init()
    yield @processManager.init()
    yield @serviceManager.run?()
    yield @processManager.run?()
    @log 'OK'
module.exports = Main

