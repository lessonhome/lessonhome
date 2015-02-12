
State   = require './state'
Module  = require './module'
fs      = require 'fs'
readdir = Q.denodeify fs.readdir
Router  = require './server/router'
_path   = require 'path'


class module.exports
  constructor : (@name)->
    @cacheRes     = {}
    @path         = {}
    @path.root    = "#{Feel.path.www}/#{@name}"
    @path.src     = "#{@path.root}/"
    @path.states  = "#{@path.src}/states"
    @path.modules = "#{@path.src}/modules"
    @path.config  = "#{@path.root}/config"
    @path.cache   = "#{Feel.path.cache}/#{@name}"
    @path.sass    = "#{@path.cache}/modules"
    @config       = {}
    @state        = {}
    @modules      = {}
    @router       = new Router @
  init : =>
    Q()
    .then @configInit
    .then @loadModules
    .then @loadStates
    .then @router.init
    .then =>
      console.log @dataObject "./example", "states/main"
  configInit : =>
    return Q() unless fs.existsSync @path.config
    return Q() unless fs.statSync(@path.config).isDirectory()
    return @configDir @path.config
  configDir : (dir)=>
    readdir dir
    .then (files)=>
      files.reduce (promise,file)=>
        stat = fs.statSync("#{dicr}/#{file}")
        if stat.isDirectory()
          return promise.then => @configDir "#{dir}/#{file}"
        if stat.isFile()
          return promise unless file.match /^(\w.*\.coffee)$/
          cfg = require process.cwd()+"/#{dir}/#{file}"
          for key,val of cfg
            @config[key] = val
          return promise
      ,Q()
    
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
      if !@state[name].class?
        delete @state[name]
        #throw new Error "can't find @class in state #{name}, seems no class @main in state fail defined"
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
        return promise
      , Q()
    .then =>
      return if !dir
      module.name = dir.match(/^(.*)\/$/)[1]
      @modules[module.name] = new Module module,@
      return @modules[module.name].init()
  dataObject : (name,context)=>
    suffix  = ""
    postfix = name
    file = ""
    m = name.match /^(\w)\:(.*)$/
    if m
      suffix  = m[1]
      postfix = m[2]
    suffix = switch suffix
      when 's' then 'states'
      when 'm' then 'modules'
      when 'r' then 'runtime'
      else ''
    m = context.match /^(\w+)\/(.*)$/
    s = m[1]
    p = m[2]
    if postfix.match /^\./
      suffix = s if !suffix
      file = _path.normalize @path.src+"/"+suffix+"/"+p+"/"+postfix+".d.coffee"
    else if postfix.match /^\//
      suffix = "runtime" if !suffix
      file = _path.normalize @path.src+"/"+suffix+postfix+".d.coffee"
    else
      suffix = "runtime" if !suffix
      file = _path.normalize @path.src+"/"+suffix+"/"+postfix+".d.coffee"
    console.log file
    obj = require process.cwd()+"/"+file
    return obj
  handler : (req,res,site)=>
    m     = req.url.match /^\/js\/(\w+)\/(.+)$/
    return @res404 req,res unless m
    if m[2].match /\.\./
      return @res404 req,res unless m
    hash    = m[1]
    module  = m[2]
    if @modules[module]?.allJs?
      res.setHeader "Content-Type", "text/javascript; charset=utf-8"
      if hash == @modules[m[2]]?.jsHash
        return @res304 req,res if req.headers['if-none-match'] == hash
        res.setHeader 'ETag', hash
        res.setHeader 'Cache-Control', 'public, max-age=126144001'
        res.setHeader 'Cache-Control', 'public, max-age=126144001'
        res.setHeader 'Expires', "Thu, 07 Mar 2086 21:00:00 GMT"
      zlib = require 'zlib'
      return zlib.deflate @modules[module].allJs,{level:9},(err,resdata)=>
        return @res404 req,res,err if err?
        res.statusCode = 200
        res.setHeader 'Content-Length', resdata.length
        res.setHeader 'Content-Encoding', 'deflate'
        return res.end resdata
    return @res404 req,res
  moduleJsUrl : (name)=>
    hash = @modules[name]?.jsHash
    "/js/#{hash}/#{name}"
  moduleJsTag : (name)=>
    "<script type='text/javascript' src='#{@moduleJsUrl(name)}'></script>"
  res404  : (req,res,err)=>
    res.writeHead 404
    res.end()
    console.error 'error',err if err?
  res304  : (req,res)=>
    res.writeHead 304
    res.end()

