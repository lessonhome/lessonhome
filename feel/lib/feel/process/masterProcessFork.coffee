###
# MasterProcessFork
# класс поддерживающий один форк потока, не поддерживает реконнект
###


class MasterProcessFork extends EE
  constructor : (@conf)->
    Wrap @
    @ee = new EE
  init : =>
    #@log @conf.name,@conf.services
    _cluster = require 'cluster'
    _cluster.setupMaster {
      exec : @conf.exec
    }
    conf = "FORK":JSON.stringify(@conf)
    @worker = _cluster.fork conf
    @worker.on 'exit', (code)=>
      return @emit 'restart',code if code
      @emit 'exit'
    @worker.on 'message', (msg)=> @message(msg).done()
    @pid = @worker.process.pid

  send    : (msg,args...)=> @worker.send {msg,args}
  receive : (args...)=>
    @ee.on args...
  receiveOnce : (args...)=>
    @ee.once args...
  message : ({msg,args})=>
    throw new Error 'undefined msg received' unless msg?
    args ?= []
    switch msg
      when 'ready'  then @emit 'ready',   args...
      when 'run'    then @emit 'run',     args...
      when 'die'
        @log "#{@conf.name}:#{@conf.processId} - die"
        @emit 'restart', args...
      when 'exit'
        @log "#{@conf.name}:#{@conf.processId} - exit"
        @emit 'exit',    args...
      else               @ee.emit msg,args...

  stop : =>
    try @worker.kill()

module.exports = MasterProcessFork

