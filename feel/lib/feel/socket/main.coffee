

http = require 'http'
url  = require 'url'

class Socket
  constructor : ->
    Wrap @
    
  init : =>
    @db = yield Main.service 'db'
    @server = http.createServer @handler
    @server.listen 8082
    @handlers = {}
  run  : =>

  handler : (req,res)=> Q.spawn =>
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
      obj.$db = @db
    ret = yield @handlers[path].handler data...
    res.statusCode = 200
    res.setHeader 'content-type','application/json; charset=UTF-8'
    res.end "#{cb}(#{ JSON.stringify( data: encodeURIComponent(JSON.stringify(ret)))});"


module.exports = Socket



