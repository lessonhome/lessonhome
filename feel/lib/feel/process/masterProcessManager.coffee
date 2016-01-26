
###
# MasterProcessManager
# управляет запуском необходимых потоков и межпоточным взаимодействием
###

_fs       = require 'fs'
_readdir  = Q.denode _fs.readdir

MasterProcess         = require './masterProcess'
MasterProcessConnector  = require './masterProcessConnector'


class MasterProcessManager
  constructor : ->
    Wrap @
    @jobs = _Helper 'jobs/main'
    @config     = {}
    @process    = {}
    @processById= {}
    @connectors = {}
    @query      = new EE
  init : =>
    @log()
    yield @setQuery()
    configs = yield _readdir 'feel/lib/feel/process/config'
    for name in configs
      continue unless m = name.match /^(\w+)\.coffee$/
      @config[m[1]] = require("./config/#{name}")
      @config[m[1]].name      = m[1]
      @config[m[1]].services ?= []
      @config[m[1]].single   ?= false
      @config[m[1]].autostart?= false
    yield @jobs.listen 'process-connect-masterServiceManager',@jobConnectMasterServiceManager
    yield @jobs.listen 'process-connect-masterProcessManager',@jobConnectMasterProcessManager
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
    @process[conf2.name].push s
    @processById[s.id] = s
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


