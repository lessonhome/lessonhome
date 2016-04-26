

http = require 'http'
http2 = require 'http2'
os = require 'os'
spdy = require 'spdy'
https = require 'https'
url  = require 'url'
_cookies = require 'cookies'
Form = require '../class/form'

class Socket
  constructor : ->
    Wrap @
  init : =>
    @workers = {}
    if Main.conf.args?.files?.length == 1
      @workerName = Main.conf.args.files[0]
      @isWorker = @workerName.match(/^workers\//)?
    else
      @isService = true
      @workerName = 'multi_service'
    unless @isWorker
      for file in (Main.conf?.args?.files ? [])
        @workers[file] = false
  runWorker : =>
    Class = require "#{process.cwd()}/www/lessonhome/#{@workerName}.c.coffee"
    obj = new Class
    obj = $W obj
    console.log "worker ".blue+@workerName.yellow
    if typeof obj.__handler == 'function'
      yield @init__Handler obj,'__handler'
    yield obj.init?()
    yield obj?.run?()
  init__Handler : (obj,handler='handler')=>
    @db = yield Main.service 'db'
    @form = new Form
    yield @form.init()
    @register = yield Main.service 'register'
    if _production
      yield @runSsh()
    else
      @server = http.createServer @handler
      @server.listen Main.conf.args.port
    @mainObject       = obj if obj?
    @handlerFunction  = handler if obj?
    
    #unless typeof global.Feel?.const == 'function'
  runSsh : =>
    options = {
      key: _fs.readFileSync '/key/server.key'
      cert : _fs.readFileSync '/key/server.crt'
      ca : _fs.readFileSync '/key/server.ca'
      ciphers: "EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM EECDH+ECDSA+SHA384 EECDH+ECDSA+SHA256 EECDH+aRSA+SHA384 EECDH+aRSA+SHA256 EECDH+aRSA+RC4 EECDH EDH+aRSA RC4 !aNULL !eNULL !LOW !3DES !MD5 !EXP !PSK !SRP !DSS !RC4"
      honorCipherOrder: true
      autoSpdy31 : true
      ssl : true
      #ca : _fs.readFileSync '/key/ca.pem'             
    }
    @sshServer = http2.createServer options,@handler
    @sshServer.listen Main.conf.args.port
  run  : =>
    @jobs = yield Main.service 'jobs'
    @const = yield @jobs.solve 'getConsts'
    global.Feel ?= {}
    global.Feel.const = (name)=> @const[name]
    return yield @runWorker() if @isWorker
    return yield @initHandler()
  initHandler : =>
    console.log "handler ".blue+@workerName.yellow
    return yield @initMulti() if @isService
    obj = yield @initObject @workerName,'handler'
  initMulti : =>
    yield @init__Handler()
  initMultiWorker : (name)=>
    obj = yield @initObject name
    @workers[name] = obj

  initObject : (name,handlerName)=>
    obj = require "#{process.cwd()}/www/lessonhome/#{name}.c.coffee"
    if obj.prototype?
      obj = $W new obj
    else for key,val of obj
      if typeof val == 'function'
        if val?.constructor?.name == 'GeneratorFunction'
          obj[key] = Q.async val
        else
          do (obj,key,val)->
            obj[key] = (args...)-> Q.then -> val.apply obj,args
    yield @init__Handler obj,handlerName if handlerName
    obj.$db = @db
    yield obj?.init?()
    yield obj?.run?()
    return obj
  handler : (req,res)=> Q.spawn =>
    unless req.url.match /^\/robots\.txt/ then switch req?.headers?.host
      when 'prep.su','localhost.ru','pi0h.org'
        res.writeHead 301, 'Location': "https://lessonhome.ru:#{Main.conf.args.port}"+req.url
        return res.end()
    host = req.headers.host
    $ = {}
    $.req = req
    $.res = res
    $.register = @register
    req.cookie = cookie = new _cookies req,res
    session = cookie.get 'session'
    unknown = cookie.get 'unknown'
    register = yield @register.register session,unknown,cookie.get('adminHash')
    session = register.session
    req.user = register.account
    cookie.set 'unknown',req.user.unknown,{httpOnly:false} unless req.user.unknown == unknown
    _ = url.parse(req.url,true)
    try
      data    = JSON.parse _.query.data
      context = JSON.parse _.query.context
      pref = JSON.parse _.query.pref
    catch e
      console.error e
      return res.end()
    cb   = _.query.callback
    path = _.pathname
    clientName = yield @resolve context,path,pref
    _max_age = null
    if @isService
      unless @workers[clientName]
        yield @initMultiWorker clientName
      _max_age = @workers[clientName]._max_age
    else
      _max_age = @mainObject._max_age
    if _max_age
      etag = Math.ceil((new Date().getTime()/1000)/_max_age)*_max_age
      if req.headers['if-none-match'] == etag
        res.statusCode = 304
        res.end()
        return
      d = new Date()
      d.setTime d.getTime()+_max_age*1000
      res.setHeader 'Expires',d.toGMTString()
      res.setHeader 'ETag',etag
      res.setHeader 'Cache-Control','public, max-age='+_max_age

    _keys = []
    for d in data
      if typeof d == 'object' && d!= null
        _keys.push '{'+Object.keys(d).join(',')+'}'
      else
        _keys.push d
    console.log "client:".blue+clientName.yellow+("::handler("+_keys.join(',')+");").grey
    $.db = @db
    do (req,res)=>
      req ?= {}
      req.status ?= {}
      req.status = (args...)=>
        @status req,res,args...
    $.status = $.req.status
    $.user = req.user
    $.session = session
    $.cookie = cookie
    $.form = @form
    $.updateUser = (session)=> @updateUser req,res,$,session
    try
      if @isService
        ret = yield @workers[clientName].handler $,data...
      else
        ret = yield @mainObject[@handlerFunction] $,data...
    catch e
      console.error Exception e
      ret = {err:"internal_error",status:'failed'}
    res.statusCode = 200
    res.setHeader 'content-type','application/json; charset=UTF-8'
    ret = ret
    #ret = JSON.stringify(ret)
    #unless ret? && typeof ret == 'string'
    #  console.error Exception new Error "failed JSON.stringify client returned object"
    #  ret = {status:"failed",err:"internal_error"}
    #res.end "#{cb}(#{ JSON.stringify( data: encodeURIComponent(ret))});"
    try
      _res_data = yield _gzip "#{cb}(#{ JSON.stringify( data: ret)});"
      res.setHeader 'content-encoding','gzip'
      res.setHeader 'content-length',_res_data.length
      res.end _res_data
      #res.end "#{cb}(#{ JSON.stringify( data: ret)});"
    catch e
      #unless ret? && typeof ret == 'string'
      console.error Exception new Error "failed JSON.stringify client returned object"
      ret = {status:"failed",err:"internal_error"}
      res.end "#{cb}(#{ JSON.stringify( data: ret)});"
  status : (req,res,name,value)=>
    db = yield @db.get 'accounts'
    status = yield _invoke db.find({id:req.user.id},{status:1}),'toArray'
    status = status?[0]?.status
    status ?= {}
    if value? && status[name]!= value
      status[name] = value
      yield _invoke db,'update', {id:req.user.id},{$set:{status:status}},{upsert:true}
    return status[name]
  updateUser : (req,res,$,session)=>
    cookie = req.cookie
    session ?= cookie.get 'session'
    unknown = cookie.get 'unknown'
    register = yield @register.register session, cookie.get('unknown'),cookie.get('adminHash')
    session = register.session
    req.user = register.account
    $.user = req.user
    cookie.set 'unknown',register.account.unknown,{httpOnly:false} if unknown != register.account.unknown

    $.user = req.user
    $.session = session
  resolve : (context,path,pref)=>
    name = pref+path.substr 1
    #"runtime#{path}.c.coffee"
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
      when 'w' then 'workers'
      else ''
    m = context.match /^(\w+)\/(.*)$/
    s = m[1]
    p = m[2]
    if postfix.match /^\./
      suffix = s if !suffix
      file = _path.normalize suffix+"/"+p+"/"+postfix
    else if postfix.match /^\//
      suffix = "runtime" if !suffix
      file = _path.normalize suffix+postfix
    else
      suffix = "runtime" if !suffix
      file = _path.normalize suffix+"/"+postfix
    return file

module.exports = Socket

