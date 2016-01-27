
http  = require 'http'
os    = require 'os'


class Http
  constructor : ->
    Wrap @
    hostname = os.hostname()
    @port = 8081
  init : =>
    @server = http.createServer (args...)=> @handler(args...).catch(@error).done()
    @server.on 'error', @error
    @domains =
      text  : {}
      reg   : []
  run : =>
    @log "listen port #{@port}"
    @server.listen @port
  error : (e)=>
    switch e.code
      when 'EADDRINUSE'
        @log 'retry listen port',@port
        setTimeout =>
          @server.close()
          @server.listen @port
        , 100
      else
        throw e

  handler : (req,res)=>
    console.log "#{req.method} \t#{req.headers.host}#{req.url}"
    req.time = new Date().getTime()
    #res.on 'finish', => console.log "time\t#{new Date().getTime() - req.time}ms\n"
    site = ""
    host = req.headers.host
    if @domains.text[host]?
      site = @domains.text[host]
    else
      for reg in @domains.reg
        if host.match reg[0]
          @domains.text[host] = reg[1]
          site = reg[1]
          break
    if !_production && !Feel.site[site]
      site = 'lessonhome'
    if Feel.site[site]?
      Q().then => Feel.site[site].router.handler req,res
      .catch (e)=>
        res.writeHead 500
        res.end 'Internal Server Error'
        console.error "Failed route #{host}#{req.url} to site #{site}:\n\t"
        throw e
      .done()
    else
      res.writeHead 404
      res.end('Unknown host')

    
module.exports = Http

