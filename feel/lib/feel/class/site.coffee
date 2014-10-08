
State = require './state'
fs      = require 'fs'
readdir = Q.denodeify fs.readdir


class module.exports
  constructor : (@sitename)->
    @path         = {}
    @path.root    = "#{Feel.path.www}/#{@sitename}"
    @path.src     = "#{@path.root}/src"
    @path.states  = "#{@path.src}/states"
    @path.modules = "#{@path.modules}/modules"
    @state        = {}
    @modules      = {}

  init : =>
    Q()
    .then @loadStates
    .done()

  loadStates : =>
    @createStates @path.states,""
  createStates : (path,dir)=>
    readdir path
    .then (files)=>
      files.reduce (promise,filename)=>
        stat = fs.statSync "#{path}/#{filename}"
        if stat.isDirectory()
          return promise.then => @createStates "#{path}/#{filename}",dir+filename+"/"
        if stat.isFile() && filename.match /^\w.*\.coffee$/
          name = dir+filename.match(/^(.*)\.\w+$/)[1]
          return promise.then => @createState name
        return promise
      , Q()
  createState : (name)=>
    if !@state[name]?
      @state[name] = new State @, name
      @state[name].init()
      return
    if !@state[name].inited
      throw new Error "create state '#{name}' circular depend"
  loadModules : =>
    @createModules @path.modules, ""
  createModules : (path,dir)=>
    readdir path
    .then (files)=>
      files.reduce (promise,filename)=>
        stat = fs.statSync "#{path}/#{filename}"
        if stat.isDirectory()
          return promise.then => @createModules "#{path}/#{filename}", dir+filename+"/"
        if stat.isFile() && filename
