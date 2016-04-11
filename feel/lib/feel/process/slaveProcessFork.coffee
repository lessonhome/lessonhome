
###
# Стартовый класс при форке потока
###

Service   = require '../service/service'
SlaveServiceManager = require '../service/slaveServiceManager'
Messanger = require './slaveProcessMessanger'

_blackList = require './blackList'

mem = -> Math.floor(process.memoryUsage().rss/(1024*1024)*100)/100
#heapdump = require 'heapdump'
class SlaveProcessFork
  constructor : ->
    $W @
  init : =>
    t = new Date().getTime()
    @conf   = JSON.parse process.env.FORK
    @jobs = _Helper 'jobs/main'
    @redis = yield _Helper('redis/main').get()
    @processId  = @conf.processId
    @name       = @conf.name
    wname = @conf.args?.file || @conf.name
    wname = wname.replace /\//gmi,'_'

    #@messanger = new Messanger()

    #yield @messanger.init()
    #@messanger.send 'ready'
    @serviceManager = new SlaveServiceManager()
    yield @serviceManager.init()
     
    qs = []
    qs.push @serviceManager.run()
    if @conf.services
      for name in @conf.services
        qs.push @serviceManager.start name
    yield Q.all qs
    Q.spawn => @jobs.solve 'slaveProcessSendToMaster','run',@processId
    #Q.spawn =>
    #  yield Q.delay 30000
    #  heapdump.writeSnapshot('heap/'+wname+@conf.processId+'.heapsnapshot')
    ###
    Q.spawn =>
      while true
        m = mem()
        #console.log "memory #{name}:".yellow,"#{m}".red
        t = (new Date().getTime())/1000
        yield _invoke @redis,'incrby','allmemory',(m*100)//1
        yield _invoke @redis,'rpush','allservices',JSON.stringify [wname,m]
        yield Q.delay ((t+15)//15*15-t)*1000
    ###
    #unless @conf.name == 'service-socket2'
    #  console.log "service ".blue,(@conf.name.yellow),new Date().getTime()-t
    #@messanger.send 'run'
  #service : (name)=> @serviceManager.nearest name
  helper  : => _Helper arguments...
  isomorph: (name)=> require "#{process.cwd()}/www/lessonhome/isomorph/#{name}.coffee"
  service : (name)=>
    serv = yield @serviceManager.nearest name,false
    return serv if serv
    black = {
      then : true
    }
    ee = new EE
    proxy = new Proxy {},{
      get : (t,key,rec)=>
        return if black[key]
        t = new Date().getTime()
        switch key
          when 'on'
            return (signal,foo)=>
              unless ee._events[signal]
                Q.spawn =>
                  yield @jobs.onSignal "process--#{name}---#{signal}",=>
                    ee.emit signal,arguments...
                  yield @jobs.solve "process--#{name}--sendSignal",signal
              ee.on signal,foo
          else
            return (args...)=> @jobs.solve "process--#{name}",key,args...
    }



module.exports = SlaveProcessFork


##################################################

#Lib = new (require '../lib')()
#_cluster = require 'cluster'

log = (msg)=>
  console.log.apply console, ["process:".cyan+"#{Main.conf.name}".blue+":#{Main.conf.processId}:#{process.pid}".grey, arguments...]

error = (msg)=>
  console.log "********************************************************".red
  console.log "ERROR".red+":process:".cyan+"#{Main.conf.name}".blue+":#{Main.conf.processId}:#{process.pid}".grey, arguments...
  console.log "********************************************************".red

process.on 'uncaughtException', (e)=>
  error "uncaughtException".red,Exception e
  process.exit 1

process.on 'exit', (code)=>
  log "exit with code".yellow+" #{code}".red
process.on 'SIGINT', =>
  log "SIGINT".red
  process.exit 0
process.on 'SIGTERM', =>
  log "SIGTERM".red
  process.exit 0

###
class Messenger extends EE
  constructor : ->
    @eemit  = => Messenger::emit.apply @,arguments
    @emit   = => @memit.apply @,arguments
    process.on 'message', @msg
  memit : (name,args...)=>
    process.send {
      msg   : name
      args  : args
    }
  msg : (o)=>
    return unless o.msg?
    args = o.args
    args?= []
    @eemit o.msg, args...
class Fork
  constructor : ->
    Wrap @
  init : ->
    Lib.init()
    .then =>
      Main_class = require "../services/#{process.env.name}/main"
      @main     = new Main_class()
      @main.DB  = new (require("../db/main"))()
      @main.parent = new Messenger()
      @main.domain = require 'domain'
      Services = require '../services'
      @main.services = new Services()
      global.Main   = @main
      @domain = @main.domain.create()
      #@domain.add @main
      @main.context = @main.domain.create()
      @domain.on 'error', (err)=>
        try
          error 'main domain handle',Exception err
          @main.onerror? err
        catch e
          error '@main.onerror?(err) error from main domain handle',Exception e
        process.exit 1
    .then =>
      @domain.run =>
        Q().then  =>
          @main.DB.init()
        .then     =>
          @main.DB.connect 'feel'
        .then (db)=>
          @main.db = db
    .then =>
      @domain.run =>
        @main.init?()
    .then =>
      @domain.run =>
        @main.parent.emit 'init'
        @main.parent.emit 'restart'
    .then =>
      @domain.run =>
        @main.run?()
    .catch (e)=>
      error "end exception",Exception e
      process.exit 1

module.exports = Fork

###
