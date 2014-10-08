
State = require './state'
Module = require './module'
fs      = require 'fs'
readdir = Q.denodeify fs.readdir


class module.exports
  constructor : (@sitename)->
    @path         = {}
    @path.root    = "#{Feel.path.www}/#{@sitename}"
    @path.src     = "#{@path.root}/src"
    @path.states  = "#{@path.src}/states"
    @path.modules = "#{@path.src}/modules"
    @state        = {}
    @modules      = {}

  init : =>
    Q()
    .then @loadStates
    .then @loadModules
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
    module        = {}
    module.files  = {}
    readdir path
    .then (files)=>
      files.reduce (promise,filename)=>
        stat = fs.statSync "#{path}/#{filename}"
        if stat.isDirectory()
          return promise.then => @createModules "#{path}/#{filename}", dir+filename+"/"
        if stat.isFile() && dir && !filename.match(/^\..*$/)
          reg = filename.match(/^(.*)\.(\w+)$/)
          filepath = "#{path}/#{filename}"
          if reg
            module.files[filename] =
              name  : reg[1]
              ext   : reg[2]
              path  : filepath
          else
            module.files[filename] =
              name : filename
              ext  : ""
              path : filepath
      , Q()
    .then =>
      return if !dir
      module.name = dir.match(/^(.*)\/$/)[1]
      @modules[module.name] = new Module module,@
      return @modules[module.name].init()

