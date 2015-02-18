
###
# MasterProcess
# класс который обеспечивает непрерывное общение с потоком
# и его запуск/перезапуск в случае падения
# работает только в мастер потоке
# Public:
# start()   - запускает поток, если не запущен, так же гарантирует его работоспособность, 
#           в случае успеха
# stop()    - останавливает поток
# restart() - перезагружает поток (stop()&start()) 
# send/receive() - аналог on,emit для обмена сообщениями с потоком
###


util = require 'util'
MasterProcessFork = require './masterProcessFork'

global.MASTERPROCESSUNIQID = 0  # uniq process id, saving when restart process

class MasterProcess extends EE
  constructor : (@conf,@manager)->
    @id   = global.MASTERPROCESSUNIQID++
    @name = @conf.name
    Wrap @
    @conf.exec  = "feel/lib/feel/process/slaveProcessFork.js"
    @runnig     = false
    @starting   = false
    @ee         = new EE
    @on 'running', => @running = true
    @listeners =
      ready   : @fReady
      restart : @fRestart
      exit    : @fExit
    @receive 'query',@query
  init    : =>
    @start()
  start   : =>
    return if @running || @starting
    @starting = true
    @fork = new MasterProcessFork @conf
    yield @bindForkEvents()
    yield @fork.init()
  stop : =>
    return unless @running || @starting
    yield @wait() if @starting
    @running = false
    yield @fork.stop()
  restart : =>
    yield @stop()
    yield @start()
  receive   : (args...)=>
    @ee.on args...
    @fork.receive args...
  send      : (args...)=>
    yield @wait()
    @fork.send args...
  #### Private ####
  # wait() - ждет запуска потока, если он прервал выполнение 
  #         (полезно перед отправкой сообщения ему)
  wait    : (foo)=>
    return foo?() if @running
    defer = Q.defer()
    @on 'running', => defer.resolve foo?()
    return defer.promise
  query : (id,name,args...)=>
    nid = "#{@id}:#{id}"
    @manager.query.once "#{name}:#{nid}", (err,data)=>
      @send "query:#{id}",err,data
    @manager.query.emit name,nid,args...
  bindForkEvents : =>
    if @listenersNow?
      for event of @listeners
        @listenersNow[event] = ->
    @listenersNow = {}
    for event,listener of @listeners
      do (event,ln=@listenersNow)=>
        ln[event] = (args...)=> @listeners[event] args...
        @fork.on event, (args)=> ln[event] args...
    for msg,arr of @ee._events
      arr ?= []
      arr = [arr] unless util.isArray arr
      @fork.receive msg,l for l in arr
  fReady    : =>
    @running = true
    @emit 'running'
  fRestart  : =>
    @restart()
  fExit     : =>
    @stop()
  

module.exports = MasterProcess


