

http = require 'http'
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
    @handlers = {}
  run  : =>

  handler : (req,res)=> Q.spawn =>
    req.cookie = cookie = new _cookies req,res
    session = cookie.get 'session'
    register = yield @register.register session
    session = register.session
    req.user = register.accaunt
    _ = url.parse(req.url,true)
    data = JSON.parse _.query.data
    cb   = _.query.callback
    path = _.pathname
    unless @handlers[path]?
      @handlers[path] = require "#{process.cwd()}/www/lessonhome/runtime#{path}.c.coffee"
      obj = @handlers[path]
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
    ret = yield @handlers[path].handler $,data...
    res.statusCode = 200
    res.setHeader 'content-type','application/json; charset=UTF-8'
    res.end "#{cb}(#{ JSON.stringify( data: encodeURIComponent(JSON.stringify(ret)))});"


module.exports = Socket



