

http  = require 'http'
spdy  = require 'spdy'
https = require 'https'
_crypto = require 'crypto'
_postdata = Q.denode require 'post-data'
os = require "os"
hostname = os.hostname()

class Server
  constructor : ->
    @_google = {}
    console.log 'hostname'.grey,hostname.red
    @port = 8081
    @ip = '127.0.0.1'
    @ip2 = '176.9.22.118'
    @ip3 = '176.9.22.124'
    if _production
      @port = 8081
      @ip = hostname
      @ssh = true
    else
      @port = 8081
  init : =>
    unless @ssh
      @server = http.createServer @handler
    else
      @server = http.createServer @handlerHttpRedirect
    if _production
      @server.listen @port,@ip
    else
      @server.listen @port
    @runSsh() if @ssh
    console.log "listen port".blue+" #{@ip}:#{@port}".yellow
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
      ca : _fs.readFileSync '/key/server.ca'
      ciphers: "EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM EECDH+ECDSA+SHA384 EECDH+ECDSA+SHA256 EECDH+aRSA+SHA384 EECDH+aRSA+SHA256 EECDH+aRSA+RC4 EECDH EDH+aRSA RC4 !aNULL !eNULL !LOW !3DES !MD5 !EXP !PSK !SRP !DSS !RC4"
      honorCipherOrder: true
      autoSpdy31 : true
      ssl : true
      #ca : _fs.readFileSync '/key/ca.pem'
    }
    @sshServer = https.createServer options,@handler
    if _production
      @sshServer.listen 8083,@ip
    else
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
    unless req.url.match /^\/robots\.txt/ then switch req?.headers?.host
      when 'prep.su','localhost.ru','pi0h.org'
        res.writeHead 301, 'Location': 'https://lessonhome.ru'+req.url
        return res.end()
    return @verify req,res if req.url.match /well-known/
    res.statusCode = 301
    host = req.headers.host
    if m = host?.match /^www\.(.*)$/
      host = m[1]
    #yield req?.udataToUrl?()
    res.setHeader 'location', "https://#{host}#{req.url}"
    res.end()
  verify : (req,res)=>
    res.setHeader 'Content-Type','text/plain'
    switch req.url
      when '/.well-known/acme-challenge/RsDJqtxTo1-NfWUFYojrWyhPuUnO26Lott2XuGAZ8F4'
        res.write 'RsDJqtxTo1-NfWUFYojrWyhPuUnO26Lott2XuGAZ8F4.XBoa84QTnDAQ0fXF-6tT9GYEyUjyclDN7Jg2fNsTjeI'
      when '/.well-known/acme-challenge/_PdrHjI10v4TuX-8_RJZIlZSgR4s3wnXwtsfziX_YPs'
        res.write '_PdrHjI10v4TuX-8_RJZIlZSgR4s3wnXwtsfziX_YPs.XBoa84QTnDAQ0fXF-6tT9GYEyUjyclDN7Jg2fNsTjeI'
    res.end()
    return
  udataToUrl : (req,res,url)=> do Q.async =>
    unless url?
      obj = req
    else
      obj = {url}
    unless req?.udata? && req?.site?
      return obj.url
    urldata = yield req.site.urldata.d2u req.udata ? {}
    if urldata
      urldata = "?#{urldata}"
    else
      urldata = ""
    obj.url = obj.url.replace /\?.*$/g,""
    obj.url += urldata
    return obj.url
    res.end()
  handler : (req,res)=>
    unless req.url.match /^\/robots\.txt/ then switch req?.headers?.host
      when 'prep.su','localhost.ru','pi0h.org'
        res.writeHead 301, 'Location': 'https://lessonhome.ru'+req.url
        return res.end()
    if (hostname!='pi0h.org') && req.url.match /^\/robots\.txt/
      req.url = '/robots_dev.txt'
    if (req?.headers?.host!='lessonhome.ru') && req.url.match /^\/robots\.txt/
      req.url = '/robots_dev.txt'
    if req.url.match /^\/tutors_search/
      res.writeHead 301, 'Location': req.url.replace '/tutors_search','/search'
      return res.end()
    if req.url.match /^\/tutor_profile/
      res.writeHead 301, 'Location': req.url.replace '/tutor_profile','/tutor'
      return res.end()
    return @verify req,res if req.url.match /well-known/
    if req.method == 'POST'
      unless req.url.match /upload/
        req.body = _postdata req
    req.udataToUrl = (url)=> @udataToUrl req,res,url
    m = req.url.match /^([^\?]*)\?(.*)$/
    if m
      req.udata = m[2]
      req.originalUrl = req.url
      #data = m[2].split '&'
      req.url  = m[1]
      #req.data = {}
      #for d in data
      #  kv = d.split '='
      #  req.data[kv[0]] = kv[1]
    else
      req.originalUrl = req.url


    if req.url == '/404'
      _end = res.end
      res.end = ->
        res.statusCode = 404
        _end.apply res,arguments
    else if req.url == '/500'
      _end = res.end
      res.end = ->
        res.statusCode = 500
        _end.apply res,arguments
    else if req.url == '/403'
      _end = res.end
      res.end = ->
        res.statusCode = 403
        _end.apply res,arguments
    if @ssh
      res.setHeader  'Strict-Transport-Security','max-age=604800; includeSubDomains; preload'
    host = req.headers.host
    if m = host?.match /^www\.(.*)$/
      res.statusCode = 301
      host = m[1]
      #yield req.udataToUrl()
      res.setHeader 'location', "//#{host}#{req.url}"
      return res.end()
    #console.log "#{req.method} \t#{req.headers.host}#{req.url}"
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
    if !_production && !Feel.site[site]?
      site = 'lessonhome'
    if Feel.site[site]?
      Q().then => Feel.site[site].router.handler req,res
      .catch (e)=>
        console.error "Failed route #{host}#{req.url} to site #{site}:\n\t"
        console.error Exception e
        unless req.url == '/500'
          req.url = "/500"
          return @handler req,res
        res.statusCode = 500
        res.end 'Internal Server Error'
      .done()
    else
      unless req.url == '/404'
        req.headers.host = Object.keys(@domains.text)?[0]
        req.url = '/404'
        return @handler req,res
      res.statusCode = 404
      res.end('Unknown host')
  run : =>





module.exports = Server

