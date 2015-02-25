
###
# Стартовый класс при форке потока
###

Service   = require '../service/service'
SlaveServiceManager = require '../service/slaveServiceManager'
Messanger = require './slaveProcessMessanger'

class SlaveProcessFork
  constructor : ->
    Wrap @
  init : =>
    @conf   = JSON.parse process.env.FORK
    @processId  = @conf.processId
    @name       = @conf.name
    @log()

    @messanger = new Messanger()
    yield @messanger.init()
    @messanger.send 'ready'
    @serviceManager = new SlaveServiceManager()
    yield @serviceManager.init()
     
    if @conf.services
      qs = for name in @conf.services
        @serviceManager.start name
      yield Q.all qs

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
