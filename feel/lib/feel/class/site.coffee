
State   = require './state'
Module  = require './module'
fs      = require 'fs'
readdir = Q.denodeify fs.readdir
Router  = require './server/router'
_path   = require 'path'
FileUpload = require './server/fileupload'
Form = require './form'

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
    @fileupload   = new FileUpload @
  init : =>
    Q()
    .then => Main.service('db')
    .then (db)=>
      @db = db
      Main.service 'register'
    .then (reg)=>
      @register = reg
      @form = new Form
      @form.init()
    .then @fileupload.init
    .then @configInit
    .then @loadModules
    .then @loadStates
    .then @router.init
    #.then =>
    #  console.log @dataObject "./example", "states/main"
  configInit : =>
    return Q() unless fs.existsSync @path.config
    return Q() unless fs.statSync(@path.config).isDirectory()
    return @configDir @path.config
  configDir : (dir)=>
    readdir dir
    .then (files)=>
      files.reduce (promise,file)=>
        stat = fs.statSync("#{dir}/#{file}")
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
    for key,val of @state
      delete @state[key]
    @createStates @path.states,""
  createStates : (path,dir)=>
    readdir path
    .then (files)=>
      files.reduce (promise,filename)=>
        stat = fs.statSync "#{path}/#{filename}"
        if stat.isDirectory()
          return promise.then => @createStates "#{path}/#{filename}",dir+filename+"/"
        if stat.isFile() && filename.match(/^\w.*\.coffee$/) && !filename.match(/^.*\.[c|d]\.coffee$/)
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
  createModules : (path,dir)=> do Q.async =>
    module        = {}
    module.files  = {}
    files = yield readdir path
    q = Q()
    for filename in files
      do (filename)=> q = q.then =>  do Q.async =>
        #files.reduce (promise,filename)=>
        stat = yield _stat "#{path}/#{filename}"
        if stat.isDirectory()
          #return promise.then =>
          yield @createModules "#{path}/#{filename}", dir+filename+"/"
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
    yield q
    return if !dir
    module.name = dir.match(/^(.*)\/$/)[1]
    @modules[module.name] = new Module module,@
    return @modules[module.name].init()
  dataObject : (name,context)=>
    console.log 'dataObject',name,context
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
    delete require.cache[require.resolve(process.cwd()+"/"+file)]
    obj = require process.cwd()+"/"+file
    for key,val of obj
      if typeof val == 'function'
        if val?.constructor?.name == 'GeneratorFunction'
          obj[key] = Q.async val
        else
          do (obj,key,val)->
            obj[key] = (args...)-> Q.then -> val.apply obj,args
    obj.$db = @db
    return obj
  handler : (req,res,site)=>
    if req.url.match /^\/upload\//
      return @fileupload.handler req,res
    if req.url.match /^\/uploaded\//
      return @fileupload.uploaded req,res
    if req.url.match /\.\./
      return @res404 req,res unless m
    if m = req.url.match /^\/js\/(\w+)\/(.+)$/
      hash    = m[1]
      module  = m[2]
      data    = @modules[module]?.allJs
      hash    = @modules[module]?.jsHash
    else if m = req.url.match /^\/jsfile\/(\w+)\/(.+)\/([\w-\.]+)$/
      hash    = m[1]
      module  = m[2]
      fname   = m[3]
      data    = @modules[module]?.jsfile fname
      console.log module,fname
      hash    = @modules[module]?.jsHash
    else if m = req.url.match /^\/jsfilet\/(\w+)\/(.+)\/([\w-\.]+)$/
      hash    = m[1]
      module  = m[2]
      fname   = m[3]
      data    = @modules[module]?.jsfilet fname
      console.log module,fname
      hash    = @modules[module]?.jsHash

    if data?
      res.setHeader "Content-Type", "text/javascript; charset=utf-8"
      if hash
        return @res304 req,res if req.headers['if-none-match'] == hash
        res.setHeader 'ETag', hash
        res.setHeader 'Cache-Control', 'public, max-age=126144001'
        res.setHeader 'Cache-Control', 'public, max-age=126144001'
        res.setHeader 'Expires', "Thu, 07 Mar 2086 21:00:00 GMT"
      zlib = require 'zlib'
      return zlib.deflate data,{level:9},(err,resdata)=>
        return @res404 req,res,err if err?
        res.statusCode = 200
        res.setHeader 'Content-Length', resdata.length
        res.setHeader 'Content-Encoding', 'deflate'
        return res.end resdata
    return @res404 req,res
  moduleJsUrl : (name)=>
    hash = @modules[name]?.jsHash
    "/js/#{hash}/#{name}"
  moduleJsFileUrl :  (name,fname)=>
    hash = @modules[name]?.jsHash
    "/jsfilet/#{hash}/#{name}/#{fname}"
  moduleJsTag : (name)=>
    "<script type='text/javascript' src='#{@moduleJsUrl(name)}'></script>"
  moduleJsFileTag : (name,fname)=>
    "<script type='text/javascript' src='#{@moduleJsFileUrl(name,fname)}'></script>"
  res404  : (req,res,err)=>
    res.writeHead 404
    res.end()
    console.error 'error',err if err?
  res304  : (req,res)=>
    res.writeHead 304
    res.end()
  status : (req,res,name,value)=> do Q.async =>
    db = yield @db.get 'accounts'
    status = yield _invoke db.find({id:req.user.id},{status:1}),'toArray'
    status = status?[0]?.status
    status ?= {}
    if value? && status[name]!= value
      status[name] = value
      yield _invoke db,'update', {id:req.user.id},{$set:{status:status}},{upsert:true}
    return status[name]
