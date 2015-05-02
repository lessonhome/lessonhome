

http  = require 'http'
spdy  = require 'spdy'
https = require 'https'
_crypto = require 'crypto'
os = require "os"


class Server
  constructor : ->
    @_google = {}
    hostname = os.hostname()
    console.log 'hostname',hostname
    @port = 8081
    switch hostname
      when 'pi0h.org'
        @port = 8081
        @ssh = true
      else
        @port = 8081

  init : =>
    unless @ssh
      @server = http.createServer @handler
    else
      @server = http.createServer @handlerHttpRedirect
    @server.listen @port
    @runSsh() if @ssh
    console.log "listen port #{@port}"
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
  runSsh : =>
    options = {
      key: _fs.readFileSync '/key/server.key'
      cert : _fs.readFileSync '/key/server.crt'
      ciphers: "EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM EECDH+ECDSA+SHA384 EECDH+ECDSA+SHA256 EECDH+aRSA+SHA384 EECDH+aRSA+SHA256 EECDH+aRSA+RC4 EECDH EDH+aRSA RC4 !aNULL !eNULL !LOW !3DES !MD5 !EXP !PSK !SRP !DSS !RC4"
      honorCipherOrder: true
      autoSpdy31 : true
      ssl : true
      #ca : _fs.readFileSync '/key/ca.pem'
    }
    @sshServer = spdy.createServer options,@handler
    @sshServer.listen 8083
  google : (req,res,params)=>
    hash = _crypto.createHash('sha1').update(params).digest('hex')
    if @_google[hash]?
      p = @_google[hash]
      res.statusCode = p.statusCode
      res.writeHead p.statusCode,p.headers
      res.write     p.data
      return res.end()
      
    result = (nres)=>
      data = ""
      res.statusCode = nres.statusCode
      res.writeHead nres.statusCode,nres.headers
      nres.on 'data',(d)=>
        res.write d
        data += d.toString()
      nres.on 'end', =>
        res.end()
        @_google[hash] ?= {}
        @_google[hash].statusCode = nres.statusCode
        @_google[hash].headers = nres.headers
        @_google[hash].data = data

    https.get "https://maps.googleapis.com/maps/api/place/autocomplete/json?#{params}&key=AIzaSyBUSFJqRf-3yY35quvhW9LY3QLwj_G9d7A", result
    .on 'error',(e)=>
      res.statusCode = 404
      res.end JSON.strinigfy e
  handlerHttpRedirect : (req,res)=>
    res.statusCode = 301
    host = req.headers.host
    if m = host.match /^www\.(.*)$/
      host = m[1]
    res.setHeader 'location', "https://#{host}#{req.url}"
    res.end()
  handler : (req,res)=>
    
    if @ssh
      res.setHeader  'Strict-Transport-Security','max-age=3600; includeSubDomains; preload'
    host = req.headers.host
    if m = host?.match /^www\.(.*)$/
      res.statusCode = 301
      host = m[1]
      res.setHeader 'location', "//#{host}#{req.url}"
      return res.end()
    console.log "#{req.method} \t#{req.headers.host}#{req.url}"
    if m = req.url.match /^\/google\?(.*)$/
      return @google req,res,m[1]
    req.time = new Date().getTime()
    #res.on 'finish', => console.log "time".yellow+"\t#{new Date().getTime() - req.time}ms".cyan
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
      Q().then => Feel.site[site].router.handler req,res
      .catch (e)=>
        res.writeHead 500
        res.end 'Internal Server Error'
        console.error "Failed route #{host}#{req.url} to site #{site}:\n\t"
        console.error Exception e
      .done()
    else
      res.writeHead 404
      res.end('Unknown host')
  run : =>





module.exports = Server

