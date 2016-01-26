

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
    
    first =  {
      services : true
    }
    last = {
      feel : true
    }
    q = []
    for name of first
      q.push yield @runByConf name,@config[name] if @config[name]
    console.log 'WAIT FOR FIRST'.red
    #yield Q.all q
    console.log 'WAIT FOR FIRST OK'.red
    q = []
    for name,conf of @config
      continue if first[name] || last[name]
      q.push yield  @runByConf name,conf
    console.log 'WAIT FOR SEC'.red,q
    #yield Q.all q
    console.log 'WAIT FOR SEC OK'.red
    q = []
    for name of last
      q.push yield @runByConf name,@config[name] if @config[name]

    console.log 'WAIT FOR 3'.red
    #yield Q.all qs
    console.log 'WAIT FOR 3 ok'.red
  runByConf : (name,conf)=>
    return unless conf.autostart && conf.single
    t = new Date().getTime()
    console.log "RUN ".red,name.yellow
    num = 1
    if _production && os.cpus().length>3
      switch name
        when 'feel'
          unless os.hostname() == 'lessonhome.org'
            num = os.cpus().length-3

    for i in [1..num]
      process = yield Main.processManager.runProcess {
          name      : 'service-'+name
          services  : [name]
      }
      yield _waitFor process,'run',10*60*1000
    console.log "RUN OK".yellow,name.yellow,"#{new Date().getTime()-t}".blue
  runService : (name,args)=>
    process = yield Main.processManager.runProcess {name:'service-'+name,services:[name],args}
    yield _waitFor process,'run',10*60*1000
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
    #@log "#{process.name}:#{processId}:#{name}"
    @services.byProcess[processId] ?= {}
    @services.byProcess[processId][serviceId] = wrapper
    @services.byId[masterId] = wrapper
    @services.byName[name] ?= []
    @services.byName[name].push wrapper
    @emit 'connected:'+name,wrapper

  get : (name)=>
    arr = @services.byName[name]
    unless _util.isArray(arr)&&arr.length
      unless @waitFor[name]
        throw new Error 'no one started service at master with name '+name
      return yield _waitFor @,'connected:'+name
    service = arr[Math.floor(Math.random()*arr.length)]
    return service

module.exports = MasterServiceManager



