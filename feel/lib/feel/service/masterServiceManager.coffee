

MasterProcessConnect = require '../process/masterProcessConnect'

global.MASTERSERVICEMANAGERSERVICEID = 0

class MasterServiceManager
  constructor : ->
    Wrap @
    @ee = new EE
    @config = {}
    @services =
      byProcess : {}
      byId      : {}
      byName    : {}
    @waitFor = {}
  init : =>
    @log()
    configs = yield _readdir 'feel/lib/feel/service/config'
    for name in configs
      continue unless m = name.match /^(\w+)\.coffee$/
      service = require "./config/#{name}"
      name = m[1]
      service.name = name
      @config[name] = service
      if service.autostart
        @waitFor[name] = true
  run  : =>
    for name,conf of Main.processManager.config
      if conf.autostart && conf.services?
        for serv in conf.services
          @waitFor[serv] = true
    @log()
    qs = []
    for name,conf of @config
      if conf.autostart && conf.single
        qs.push Main.processManager.runProcess {
          name      : 'service-'+name
          services  : [name]
        }
    yield Q.all qs
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
  connectService : (processId,serviceId)=>
    process = yield Main.processManager.getProcess processId
    service = new MasterProcessConnect {
      type  : 'service'
      id    : serviceId
    }, process
    yield service.__init()
    wrapper = service
    masterId  = MASTERSERVICEMANAGERSERVICEID++
    name      = yield service.__serviceName
    @log "#{process.name}:#{processId}:#{name}"
    @services.byProcess[processId] ?= {}
    @services.byProcess[processId][serviceId] = wrapper
    @services.byId[masterId] = wrapper
    @services.byName[name] ?= []
    @services.byName[name].push wrapper
    @ee.emit 'connected:'+name,wrapper

  get : (name)=>
    @log name
    arr = @services.byName[name]
    unless _util.isArray(arr)&&arr.length
      unless @waitFor[name]
        throw new Error 'no one started service at master with name '+name
      return yield @waitAction 'connected:'+name
    service = arr[Math.floor(Math.random()*arr.length)]
    return service

module.exports = MasterServiceManager



