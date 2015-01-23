

_cluster = require 'cluster'

class Service extends EE
  constructor : (@name,@index)->
    @id = "worker:#{@index}"
    @master = _cluster.isMaster
    
    if @master
      _cluster.setupMaster {
        exec : "feel/lib/feel/service/fork.js"
      }
    @on 'message',@message
    @emit.apply @,['message',[1,2,3,4]...]
    @on 'disconnect', @disconnect
    @on 'exit', @exit
    @online     = false
    @messenger  = new EE
    @messenger.service = @
    @messenger.eemit = => EE::emit.apply @messenger,arguments
    @messenger.emit = @memit
    @marray = []
    @messenger.on 'init', =>
      @started = true
      @memit()
    @messenger.on 'restart', (@restart=true)=>
  init : (@args={})=>
    @start()

  start : =>
    @restart = false
    if @master
      @worker = _cluster.fork @args
      @worker.on 'disconnect',  => @emit.apply @,[ 'disconnect',arguments... ]
      @worker.on 'exit',        => @emit.apply @,[ 'exit',      arguments... ]
      @worker.on 'message',(msg)=> @emit 'message', msg
      @worker.on 'online',      =>
        @emit 'online'
        @online = true
    else
      Main.parent.emit "fork",@name,@id,@args
      Main.parent.on "#{@id}:disconnect",  => @emit.apply @,['disconnect',arguments...]
      Main.parent.on "#{@id}:exit",        => @emit.apply @,['exit',arguments...]
      Main.parent.on "#{@id}:message",(msg)=> @emit 'message', msg
      Main.parent.on "#{@id}:online", (msg)=> @online = true
  message : (o)=>
    return unless o?.msg?
    msg   = o.msg
    args  = o.args
    args ?= []
    @messenger.eemit msg, args...
  disconnect : =>
    @online   = false
    @started  = false
  exit  : (@code)=>
    return @destructor() unless @code
    return @destructor() unless @restart
    delete @worker if @master
    @online   = false
    @started  = false
    @start()
  destructor : =>
    @emit 'destruct'
    @messenger.eemit 'destruct'
  memit : (name,args...)=>
    if name? && args?
      o = {name,args}
      @marray.push o
    return unless @started
    for o in @marray
      if @master
        @worker.send {
          msg   : o.name
          args  : o.args
        }
      else
        Main.parent.emit "#{@id}:send", {msg:o.name,args:o.args}
    @marray = []

module.exports = Service




