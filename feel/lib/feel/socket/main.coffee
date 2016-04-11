

http = require 'http'
https = require 'https'
os = require 'os'
spdy = require 'spdy'
url  = require 'url'
_cookies = require 'cookies'
Form = require '../class/form'

defaultHandlers = ['modules/main/preview/tutors']

class Socket
  constructor : ->
    Wrap @
    
  init : =>
    @db = yield Main.service 'db'
    @form = new Form
    yield @form.init()
    @register = yield Main.service 'register'
    @server = http.createServer @handler
    @port = 8082
    @server.listen @port
    if _production
      yield @runSsh()
    @handlers = {}
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
    @sshServer = https.createServer options,@handler
    @port = 8084
    @sshServer.listen @port
  run  : =>
    yield for handler in defaultHandlers
      @initHandler handler
  initHandler : (clientName)=>
    unless @handlers[clientName]?
      @handlers[clientName] = require "#{process.cwd()}/www/lessonhome/#{clientName}.c.coffee"
      obj = @handlers[clientName]
      for key,val of obj
        if typeof val == 'function'
          if val?.constructor?.name == 'GeneratorFunction'
            obj[key] = Q.async val
          else
            do (obj,key,val)->
              obj[key] = (args...)-> Q.then -> val.apply obj,args
      obj.$db = @db
      yield obj?.init?()

  handler : (req,res)=> Q.spawn =>
    unless req.url.match /^\/robots\.txt/ then switch req?.headers?.host
      when 'prep.su','localhost.ru','pi0h.org'
        res.writeHead 301, 'Location': "https://lessonhome.ru:#{@port}"+req.url
        return res.end()
    host = req.headers.host
    console.log host
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
    _keys = []
    for d in data
      if typeof d == 'object' && d!= null
        _keys.push '{'+Object.keys(d).join(',')+'}'
      else
        _keys.push d
    console.log "client:".blue+clientName.yellow+("::handler("+_keys.join(',')+");").grey
    yield @initHandler clientName
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
      ret = yield @handlers[clientName].handler $,data...
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
    console.log session
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
      when 'w' then 'workers'
      when 'r' then 'runtime'
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

