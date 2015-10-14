

MasterProcessConnect = require '../process/masterProcessConnect'

global.MASTERSERVICEMANAGERSERVICEID = 0

class MasterServiceManager
  constructor : ->
    Wrap @
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
    os = require 'os'
    
    for name,conf of @config
      if conf.autostart && conf.single
        num = 1
        num = 3 if os.hostname() == 'pi0h.org' && name=="feel" && os.cpus().length>8
        #num = os.cpus().length if os.hostname() == 'pi0h.org' && name=="feel" && os.cpus().length>8
        _q = Q()

        if num != 1
          for i in [1..num]
            do (name,conf)=>
              _q = _q.then =>
                Main.processManager.runProcess {
                  name      : 'service-'+name
                  services  : [name]
                }
              _q = _q.then (p)=>
                _waitFor p,'run',3*60*1000
          qs.push _q
        else
          qs.push Main.processManager.runProcess {
            name      : 'service-'+name
            services  : [name]
          }
    yield Q.all qs
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
    @emit 'connected:'+name,wrapper

  get : (name)=>
    @log name
    arr = @services.byName[name]
    unless _util.isArray(arr)&&arr.length
      unless @waitFor[name]
        throw new Error 'no one started service at master with name '+name
      return yield _waitFor @,'connected:'+name
    service = arr[Math.floor(Math.random()*arr.length)]
    return service

module.exports = MasterServiceManager



