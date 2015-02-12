


class MasterServiceFork extends EE
  constructor : (@conf)->
    Wrap @
    @ee = new EE
  init : =>
    _cluster = require 'cluster'
    _cluster.setupMaster {
      exec : @conf.exec
    }
    @worker = _cluster.fork @conf.args
    @worker.on 'exit', (code)=>
      return @emit 'restart',code if code
      @emit 'exit'
    @worker.on 'message', (msg)=> @message(msg).done()
    @pid = @worker.process.pid

  send    : (msg,args...)=> @worker.send {msg,args}
  receive : (args)=> @ee.on args...
  message : ({msg,args})=>
    throw new Error 'undefined msg received' unless msg?
    args ?= []
    switch msg
      when 'ready'  then @emit 'ready',   args...
      when 'die'    then @emit 'restart', args...
      when 'exit'   then @emit 'exit',    args...
      else               @ee.emit msg,args...



module.exports = MasterServiceFork

