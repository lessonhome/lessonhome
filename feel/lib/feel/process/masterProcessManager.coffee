
###
# MasterProcessManager
# управляет запуском необходимых потоков и межпоточным взаимодействием
###

_fs       = require 'fs'
_readdir  = Q.denode _fs.readdir

MasterProcess           = require './masterProcess'
MasterProcessConnector  = require './masterProcessConnector'


class MasterProcessManager
  constructor : ->
    Wrap @
    @config     = {}
    @process    = {}
    @processById= {}
    @connectors = {}
    @query      = new EE
  init : =>
    yield @setQuery()
    configs = yield _readdir 'feel/lib/feel/process/config'
    for name in configs
      continue unless m = name.match /^(\w+)\.coffee$/
      @config[m[1]] = require("./config/#{name}")
      @config[m[1]].name = m[1]
  run : =>
    qs = []
    for name,conf of @config
      if conf.autostart
        qs.push @runProcess conf
    Q.all qs
  getProcess : (id)=> @processById[id]
  runProcess : (conf)=>
    @process[conf.name] ?= []
    return if (@process[conf.name].length>0)&&(conf.single)
    s = new MasterProcess conf,@
    @process[conf.name].push s
    @processById[s.id] = s
    return s.init()
  setQuery : =>
    @query.__emit = @query.emit
    @query.emit   = (name,id,args...)=>
      if !@["q_"+name]?
        @query._emit "#{name}:#{id}", new Error 'unknown query '+name+' to master process'
      else
        @["q_"+name](args...)
        .then (data)=>
          @query.__emit "#{name}:#{id}",null,data
        .catch (err)=>
          @query.__emit "#{name}:#{id}",ExceptionJson err
  q_nearest : (args...)=>
  q_connect : (conf)=>
    connector = new MasterProcessConnector conf,@,@getProcess conf.processId
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


