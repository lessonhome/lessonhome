
util = require 'util'

SlaveProcessConnect = require '../process/slaveProcessConnect'
Service             = require './service'
_blackList = require '../process/blackList'
class SlaveServiceManager
  constructor : ->
    Wrap @
    @services =
      self    : {}
      master  : {}
      others  : {}
    @waitFor = {}
    @serviceById = {}
    @jobs = _Helper 'jobs/main'
  init : =>
    @redis = yield _Helper('redis/main').get()
    #@log()
    
    ###
    @master = new SlaveProcessConnect 'masterServiceManager'
    yield @master.__init()
    @config = yield @master.config
    ###
    @config = JSON.parse yield _invoke @redis,'get','__masterProcessConfig'
    
    #for name,conf of @config
    #  if conf.autostart && !conf.single
    #    @waitFor[name] = true
    for serv in Main.conf.services
      @waitFor[serv] = true
  run : =>
    #qs = []
    #for name,conf of @config
    #  if conf.autostart && !conf.single
    #    qs.push @start name
    #yield Q.all qs

  nearest : (name,any=true)=>
    return @choose(@services.self[name])    if @services.self[name]?[0]?
    return @choose(@services.master[name])  if @services.master[name]?[0]? && any
    return @choose(@services.others[name])  if @services.others[name]?[0]? && any
    return @waitForService name             if @waitFor[name]
    if @config[name]?.autostart && !@config[name]?.single
      return yield @start name
    return @masterNearest(name) if any
    return false
  getById : (id)=>
    return @serviceById[id] if @serviceById[id]?
    return yield _waitFor @,"connectedId:"+id
    
  waitForService : (name)=>
    defer = Q.defer()
    waited = false
    return yield _waitFor @,'connected:'+name
  choose : (array)=>
    throw new Error 'cant choose service bad array' unless util.isArray(array) && array.length
    return array[Math.floor(Math.random()*array.length)]

  masterNearest : (name)=>
    @waitFor[name] = true
    service = new SlaveProcessConnect {
      type : 'serviceNearest'
      name : name
    }
    yield service.__init()
    @emit 'connected:'+name,service
    @services.master[name] ?= []
    @services.master[name].push service
    return service
  start   : (name)=>
    @waitFor[name] = true
    #@log name
    conf    = @config[name]
    #try return @nearest name if conf.single
    service = new Service conf
    wrapper = yield service.get()
    
    qs = []
    #unless conf.autostart && !conf.single
    #  qs.push @connectServiceToMaster(service)
    yield service.init()
  
    Q.spawn =>
      ee = {}
      yield @jobs.listen "process--#{name}", (key,args...)=>
        unless typeof wrapper.__service[key] == 'function'
          throw new Error "undefined service:#{name}::#{key}()"
        wrapper.__service[key] args...
      yield @jobs.listen "process--#{name}--sendSignal",(signal)=>
        return if ee[signal]
        ee[signal] = true
        wrapper.__service.on signal,(args...)=> Q.spawn =>
          @jobs.signal "process--#{name}---#{signal}",args...

    ###
    for key,val of service
      continue unless typeof val == 'function'
      continue if _blackList key
      do (key)=> Q.spawn => @jobs.listen "process--#{name}--#{key}", => service[key] arguments...
    ###
    @serviceById[service.id] = wrapper
    @services.self[name] ?= []
    @services.self[name].push wrapper
    @emit 'connectedId:'+service.id,wrapper
    @emit 'connected:'+name,wrapper
    qs.push service.run()
    yield Q.all qs
    return wrapper
  connectServiceToMaster : (service)=>
    console.log "ERRR CONNECT",service
    yield @master.connectService Main.processId,service.id

    

module.exports = SlaveServiceManager

