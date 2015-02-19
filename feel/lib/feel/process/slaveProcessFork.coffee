
###
# Стартовый класс при форке потока
###

Service   = require '../service/service'
ServiceSlaveManager = require '../service/serviceSlaveManager'
Messanger = require './slaveProcessMessanger'

class SlaveProcessFork
  constructor : ->
    Wrap @
  init : =>
    @conf   = JSON.parse process.env.FORK
    @messanger = new Messanger()
    yield @messanger.init()
    @serviceManager = new ServiceSlaveManager()
    @messanger.send 'ready'
    yield @serviceManager.init()

    service = new Service @conf
    @service = yield service.init()

module.exports = SlaveProcessFork


##################################################

#Lib = new (require '../lib')()
#_cluster = require 'cluster'

log = (msg)=>
  console.log.apply console, ["process:#{Main.conf.name}:#{Main.conf.processId}:#{process.pid}", arguments...]

error = (msg)=>
  console.error "********************************************************"
  console.error "EE:process:#{Main.conf.name}:#{Main.conf.processId}:#{process.pid}", arguments...
  console.error "********************************************************"

process.on 'uncaughtException', (e)=>
  error "uncaughtException",Exception e
  process.exit 1

process.on 'exit', (code)=>
  log "exit with code #{code}"
process.on 'SIGINT', =>
  log "SIGINT"
  process.exit 0
process.on 'SIGTERM', =>
  log "SIGTERM"
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
