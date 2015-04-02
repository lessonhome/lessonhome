

http = require 'http'
os = require 'os'
spdy = require 'spdy'
url  = require 'url'
_cookies = require 'cookies'

class Socket
  constructor : ->
    Wrap @
    
  init : =>
    @db = yield Main.service 'db'
    @register = yield Main.service 'register'
    @server = http.createServer @handler
    @server.listen 8082
    if os.hostname() == 'pi0h.org'
      yield @runSsh()
    @handlers = {}
  runSsh : =>
    options = {
      key: _fs.readFileSync '/key/server.key'
      cert : _fs.readFileSync '/key/server.crt'
      ca : _fs.readFileSync '/key/ca.pem'             
    }                       
    @sshServer = spdy.createServer options,@handler 
    @sshServer.listen 8084
  run  : =>

  handler : (req,res)=> Q.spawn =>
    req.cookie = cookie = new _cookies req,res
    session = cookie.get 'session'
    register = yield @register.register session
    session = register.session
    req.user = register.account
    _ = url.parse(req.url,true)
    data    = JSON.parse _.query.data
    context = JSON.parse _.query.context
    pref = JSON.parse _.query.pref
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
    $ = {}
    $.db = @db
    $.req = req
    $.res = res
    $.user = req.user
    $.session = session
    $.cookie = cookie
    $.register = @register
    try
      ret = yield @handlers[clientName].handler $,data...
    catch e
      console.error Exception e
      ret = {err:"internal_error",status:'failed'}
    res.statusCode = 200
    res.setHeader 'content-type','application/json; charset=UTF-8'
    res.end "#{cb}(#{ JSON.stringify( data: encodeURIComponent(JSON.stringify(ret)))});"

  resolve : (context,path,pref)=>
    console.log pref
    name = pref+path.substr 1
    console.log context,name
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

