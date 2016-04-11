
###
# MasterProcessManager
# управляет запуском необходимых потоков и межпоточным взаимодействием
###

_fs       = require 'fs'
_readdir  = Q.denode _fs.readdir

MasterProcess         = require './masterProcess'
MasterProcessConnector  = require './masterProcessConnector'

mem = -> Math.floor(process.memoryUsage().rss/(1024*1024)*100)/100

class MasterProcessManager
  constructor : ->
    Wrap @
    @jobs = _Helper 'jobs/main'
    @config     = {}
    @process    = {}
    @processById= {}
    @connectors = {}
    @query      = new EE
    @jobs = _Helper 'jobs/main'
  init : =>
    @redis = yield _Helper('redis/main').get()

    ###
    Q.spawn => while true
      m = mem()
      #console.log "mastermprocess:".yellow,"#{m}".red
      
      t = (new Date().getTime())/1000
      all = yield _invoke @redis,'get','allmemory'
      yield _invoke @redis,'set','allmemory',0
      list = yield _invoke @redis,'lrange','allservices',0,-1
      list ?= []
      yield _invoke @redis,'del','allservices'
      for l,i in list
        list[i] = JSON.parse l
      list.push ['master',m]
      list.sort (a,b)-> a[1]-b[1]
      total = 0
      service = 0
      for l in list
        console.log "memory #{l[0]}:".yellow,"#{l[1]}Mb".red
        total += l[1]
        service += l[1] if l[0].match /service-/
      all /= 100
      all += m
      console.log "total usage: #{all}".red,service,all-service
      console.log 'del',del = ((t+15)//15*15+10-t)*1000
      yield Q.delay del
    ###
    @log()
    yield @setQuery()
    yield @jobs.listen 'slaveProcessSendToMaster',@slaveProcessSendToMaster
    configs = yield _readdir 'feel/lib/feel/process/config'
    for name in configs
      continue unless m = name.match /^(\w+)\.coffee$/
      @config[m[1]] = require("./config/#{name}")
      @config[m[1]].name      = m[1]
      @config[m[1]].services ?= []
      @config[m[1]].single   ?= false
      @config[m[1]].autostart?= false
    #yield @jobs.listen 'process-connect-masterServiceManager',@jobConnectMasterServiceManager
    #yield @jobs.listen 'process-connect-masterProcessManager',@jobConnectMasterProcessManager
  slaveProcessSendToMaster : (name,data)=>
    switch name
      when 'run'
        @processById[data]?.emit? name
        

  run : =>
    @log()
    qs = []
    for name,conf of @config
      if conf.autostart
        qs.push @runProcess conf
    Q.all qs
  getProcess : (id)=> @processById[id]
  runProcess : (conf,args={})=>
    if typeof conf == 'string'
      conf = @config[conf]
    conf2 = {}
    for key,val of conf
      conf2[key] = val
    if _util.isArray(args)
      conf2.services ?= []
      conf2.services.push s for s in args
      args = {}
    for key,val of args
      conf2[key] = val
    #@log conf2.name
    @process[conf2.name] ?= []
    return if (@process[conf2.name].length>0)&&(conf2.single)
    s = new MasterProcess conf2,@
    @processById[s.id] = s
    @process[conf2.name].push s
    return s.init()
  setQuery : =>
    @query.__emit = @query.emit
    @query.emit   = (name,id,args...)=>
      if !@["q_"+name]?
        @query.__emit "#{name}:#{id}", ExceptionJson new Error 'unknown query '+name+' to master process'
      else
        @["q_"+name](args...)
        .then (data)=>
          @query.__emit "#{name}:#{id}",null,data
        .catch (err)=>
          @query.__emit "#{name}:#{id}",ExceptionJson err
  q_nearest : (args...)=>
  jobConnectMasterProcessManager : (conf)=>
  jobConnectMasterServiceManager : (conf)=>
  q_connect : (conf)=>
    connector = new MasterProcessConnector conf, yield @getProcess conf.processId
    yield connector.init()
    @connectors[connector.id] = connector
    connector.data()
  q_connectorFunction : (id,name,args...)=>
    @connectors[id].qFunction name,args...
  q_connectorVarGet : (id,name)=>
    @connectors[id].qVarGet name
  q_connectorVarSet : (id,name,val)=>
    @connectors[id].qVarSet name,val
  q_connectorOn   : (id,action)=>
    @connectors[id].qOn action
  q_connectorEmit : (id,action,data...)=>
    @connectors[id].qEmit action,data...

module.exports = MasterProcessManager


