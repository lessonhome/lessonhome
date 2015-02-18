
###
# MasterProcessManager
# управляет запуском необходимых потоков и межпоточным взаимодействием
###

_fs       = require 'fs'
_readdir  = Q.denode _fs.readdir

MasterProcess = require './masterProcess'

class MasterProcessManager
  constructor : ->
    Wrap @
    @config   = {}
    @process  = {}
    @query    = new EE
  init : =>
    yield @setQuery()
    configs = yield _readdir 'feel/lib/feel/process/config'
    for name in configs
      continue unless m = name.match /^(\w+)\.coffee$/
      @config[m[1]] = require("./config/#{name}")
      @config[m[1]].name = m[1]
    qs = []
    for name,conf of @config
      if conf.masterstart
        qs.push @runProcess conf
    yield Q.all qs
  runProcess : (conf)=>
    @process[conf.name] ?= []
    s = new MasterProcess conf,@
    @process[conf.name].push s
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
          @query.__emit "#{name}:#{id}",Exception err
  q_nearest : (args...)=>
module.exports = MasterProcessManager


