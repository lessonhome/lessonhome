

http = require 'http'


class Server
  constructor : ->
  init : =>
    @server = http.createServer @handler
    @server.listen 8081
    @domains =
      text : {}
      reg  : []
    for sitename,site of Feel.site
      if site.config.domains?
        switch typeof site.config.domains
          when 'string'
            @domains.text[site.config.domains] = sitename
          when 'object'
            if site.config.domains instanceof RegExp
              @domains.reg.push [site.config.domains,sitename]
            else if site.config.domains.length
              for domain in site.config.domains
                if typeof domain == 'string'
                  @domains.text[domain] = sitename
                if domain instanceof RegExp
                  @domains.reg.push [domain,sitename]
        
    return Q()
  handler : (req,res)=>
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
    if Feel.site[site]?
      Q(Feel.site[site].router.handler).call Feel.site[site.router], req,res
      .catch (e)=>
        res.writeHead 500
        res.end 'Internal Server Error'
        console.error "Failed route #{host}#{req.url} to site #{site}:\n\t"
        throw e
      .done()
    else
      res.writeHead 404
      res.end('Unknown host')
  run : =>





module.exports = Server

