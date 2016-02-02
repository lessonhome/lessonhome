
utils = require 'util'
http  = require 'http'
https  = require 'https'
spdy  = require 'spdy'
os    = require 'os'
spawn = require('child_process').spawn
ps    = require 'ps-node'
_fs = require 'fs'
Q = require 'q'

class module.exports
  constructor : ->
    @port = 8888
    @updating = false
  run : ->
    switch os.hostname()
      when 'pi0h.org','lessonhome.ru','lessonhome.org'
        @ssh = true
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
    unless @ssh
      @server = http.createServer @handler
    else
      @server = https.createServer options,@handler
    @hand = 0
    @server.listen @port
  handler :(req,res)=> Q.spawn =>
    try
      yield @fhandler(req,res)
    catch e
      yield @exec "sudo",["systemctl","start","feel.service"], res
      throw e
  fhandler : (req,res)=> do Q.async =>
    if @ssh
      res.setHeader  'Strict-Transport-Security','max-age=604800; includeSubDomains; preload'
    return process.exit(0) if req.url == "/restart"
    return @tail(req,res,1000) if req.url != "/update"

    @updating = true
    @hand++
    res.setHeader 'x-content-type-options', 'nosniff'
    res.setHeader 'Connection', 'Transfer-Encoding'
    res.setHeader 'Content-Type', 'text/plain; charset=utf-8'
    res.setHeader 'Transfer-Encoding', 'chunked'
    boo = false
    res.on 'close', =>
      res.closed = true
      @end(res)
    yield @exec "sudo",["systemctl","stop","feel.service"], res
    list = yield Q.ninvoke ps, 'lookup', {
      command : 'iojs'
      psargs : "aux"
    }
    if typeof list =='object'  && list != null
      @log res, utils.inspect list
    for p in list then for a in p.arguments then if a.match(/feel\/bin\/feel/) || a.match(/feel\/lib\/feel\/process.*/)
      @log res,"#{process.cwd()} $ kill "+p.pid+"\n"
      ps.kill p.pid, =>
      boo = true
    if !boo
      @log res, "Can't find process node:feel!\n"
    yield @exec "git", ["pull"], res
    yield @exec "cat", ["./feel/version"], res
    process.chdir 'feel'
    yield @exec "npm",["i"],res
    process.chdir '..'
    yield @exec "sudo",["systemctl","start","feel.service"], res
    @exec "sudo", ["journalctl","-f","-n","0","-u","feel.service"],res,600000
    .then => @end res
  tail : (req,res,num=30)=>
    res.on 'close', =>
      res.closed = true
      @end(res)
    #@exec "tail", ["-f","-n","#{num}","/var/log/upstart/feel.log"],res,1200000, => @end res
    @exec "sudo", ["journalctl","-f","-n","#{num}","-u","feel.service"],res,1200000,=>@end res

  end : (res)=>
    return if res.closed
    res.end "====================================="
    @hand--
    if @hand <= 0
      process.exit()
  log : (res,msg)=>
    process.stdout.write msg
    if msg?.toString?()
      msg = msg.toString()
    if typeof msg == 'string'
      msg = msg.replace /\[\d\dm/g,""
    res.write msg

  exec : (cmd,args,res,time)=>
    defer = Q.defer()
    t = new Date().getTime()

    @log res, "#{process.cwd()} $ "+cmd+" "+args.join(" ")+"\n"
    prog = spawn cmd, args
    prog.stdout.on 'data', (data)=> @log res,data
    prog.stderr.on 'data', (data)=> @log res,data
    prog.on 'close', (code)=>
      if false # time?
        nt = new Date().getTime()
        if nt-t<time
          return defer.resolve @exec cmd,args,res,time-(nt-t)
      defer.resolve()

    if time
      setTimeout =>
        prog.kill()
      , time
    return defer.promise




