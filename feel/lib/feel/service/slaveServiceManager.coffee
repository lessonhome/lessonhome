
util = require 'util'

SlaveProcessConnect = require '../process/slaveProcessConnect'
Service             = require './service'

class SlaveServiceManager
  constructor : ->
    Wrap @
    @ee = new EE
    @services =
      self    : {}
      master  : {}
      others  : {}
    @waitFor = {}
    @serviceById = {}
  init : =>
    @log()
    @master = new SlaveProcessConnect 'masterServiceManager'
    yield @master.__init()
    @config = yield @master.config
    for name,conf of @config
      if conf.autostart && !conf.single
        @waitFor[name] = true
    for serv in Main.conf.services
      @waitFor[serv] = true
  run : =>
    qs = []
    for name,conf of @config
      if conf.autostart && !conf.single
        qs.push @start name
    yield Q.all qs

  nearest : (name)=>
    return @choose(@services.self[name])    if @services.self[name]?[0]?
    return @waitForService name             if @waitFor[name]
    return @choose(@services.master[name])  if @services.master[name]?[0]?
    return @choose(@services.others[name])  if @services.others[name]?[0]?
    return @masterNearest(name)
  getById : (id)=>
    return @serviceById[id] if @serviceById[id]?
    return yield @waitAction "connectedId:"+id
    
  waitAction : (action,time=1000)=>
    waited = false
    defer = Q.defer()
    @ee.once action, (args)=>
      waited = true
      defer.resolve args
    setTimeout =>
      return if waited
      defer.reject "timout waiting action #{action}"
      return
    ,time
    return defer.promise
  waitForService : (name)=>
    defer = Q.defer()
    waited = false
    return yield @waitAction 'connected:'+name
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
    @ee.emit 'connected:'+name,service
    @services.master[name] ?= []
    @services.master[name].push service
    return service
  start   : (name)=>
    @waitFor[name] = true
    @log name
    conf    = @config[name]
    #try return @nearest name if conf.single
    service = new Service conf
    wrapper = yield service.get()
    
    qs = []
    qs.push @connectServiceToMaster(service)
    yield service.init()
    @log 'Qall',name.red
    @serviceById[service.id] = wrapper
    @services.self[name] ?= []
    @services.self[name].push wrapper
    @log '::emit'.red,name
    @ee.emit 'connectedId:'+service.id,wrapper
    @ee.emit 'connected:'+name,wrapper
    qs.push service.run()
    yield Q.all qs
    return wrapper
  connectServiceToMaster : (service)=>
    @log ("connect "+service.name).red,service.id
    yield @master.connectService Main.processId,service.id
    @log ("connected "+service.name).red

    

module.exports = SlaveServiceManager

