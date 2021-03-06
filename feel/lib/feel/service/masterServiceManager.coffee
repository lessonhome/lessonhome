

MasterProcessConnect = require '../process/masterProcessConnect'

global.MASTERSERVICEMANAGERSERVICEID = 0

os = require 'os'

class MasterServiceManager
  constructor : ->
    $W @
    @config = {}
    @services =
      byProcess : {}
      byId      : {}
      byName    : {}
    @waitFor = {}
    @redis = _Helper('redis/main').get()
    @jobs = _Helper 'jobs/main'
  init : =>
    configs = yield _readdir 'feel/lib/feel/service/config'
    for name in configs
      continue unless m = name.match /^(\w+)\.coffee$/
      service = require "./config/#{name}"
      name = m[1]
      service.name = name
      @config[name] = service
      if service.autostart
        @waitFor[name] = true
    @redis = yield @redis
    yield _invoke @redis,'set','__masterProcessConfig',JSON.stringify @config
    yield @jobs.listen 'masterServiceManager-runServices',(args...)=> @runServices args...
    
    
  run  : =>
    for name,conf of Main.processManager.config
      if conf.autostart && conf.services?
        for serv in conf.services
          @waitFor[serv] = true
    
    first =  {
      services : true
    }
    last = {
      feel : true
    }
    q = []
    for name of first
      q.push @runByConf name,@config[name] if @config[name]
    #yield Q.all q
    #q = []
    for name,conf of @config
      continue if first[name] || last[name]
      q.push @runByConf name,conf
    #yield Q.all q
    #q = []
    for name of last
      q.push @runByConf name,@config[name] if @config[name]
    yield Q.all q
  runByConf : (name,conf)=>
    return unless conf.autostart && conf.single
    t = new Date().getTime()
    num = 1
    if _production && os.cpus().length>3
      switch name
        when 'feel'
          #unless os.hostname() == 'lessonhome.org'
          num = os.cpus().length-3
    for i in [1..num]
      process = yield Main.processManager.runProcess {
          name      : 'service-'+name
          services  : [name]
      }
      yield _waitFor process,'run',10*60*1000
    console.log "Started: ".blue,name.yellow,"\t#{new Date().getTime()-t}ms".blue
  runService : (name,args)=>
    process = yield Main.processManager.runProcess {name:'service-'+name,services:[name],args}
    yield _waitFor process,'run',10*60*1000
  runServices : (arr)=>
    qs = []
    for a in arr
      qs.push @runService a[0],a[1]
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



