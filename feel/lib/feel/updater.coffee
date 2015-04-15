

http  = require 'http'
spdy  = require 'spdy'
os    = require 'os'
spawn = require('child_process').spawn
ps    = require 'ps-node'
_fs = require 'fs'

class module.exports
  constructor : ->
    @port = 8888
    @updating = false
  run : ->
    #return if os.hostname() != 'pi0h.org'
    @ssh = true if os.hostname() == 'pi0h.org'
    options = {
      key: _fs.readFileSync '/key/server.key'
      cert : _fs.readFileSync '/key/server.crt'
      ciphers: "EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM EECDH+ECDSA+SHA384 EECDH+ECDSA+SHA256 EECDH+aRSA+SHA384 EECDH+aRSA+SHA256 EECDH+aRSA+RC4 EECDH EDH+aRSA RC4 !aNULL !eNULL !LOW !3DES !MD5 !EXP !PSK !SRP !DSS !RC4"
      honorCipherOrder: true
      autoSpdy31 : true
      ssl : true
      #ca : _fs.readFileSync '/key/ca.pem'
    }
    unless @ssh
      @server = http.createServer @handler
    else
      @server = spdy.createServer options,@handler
    @hand = 0
    @server.listen @port
  handler :(req,res)=>
    if @ssh
      res.setHeader  'Strict-Transport-Security','max-age=3600; includeSubDomains; preload'
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

    @exec "git", ["pull"], res, =>
      process.chdir 'feel'
      @exec "npm",["i"],res, =>
        process.chdir '..'
        ps.lookup {
          command : '/usr/bin/iojs'
          psargs : "aux"
        }, (err,list)=>
          @exec "cat", ["./feel/version"], res, =>
            @log list
            if !err
              for p in list
                for a in p.arguments
                  if a.match(/feel\/bin\/feel/) || a.match(/feel\/lib\/process.*/)
                    @log res,"#{process.cwd()} $ kill "+p.pid+"\n"
                    @exec "tail", ["-f","-n","0","/var/log/upstart/feel.log"],res,600000, => @end res
                    ps.kill p.pid, =>
                    boo = true

            if !boo
              @log res, "Can't find process node:feel!\n"
              @end res
  tail : (req,res,num=30)=>
    res.on 'close', =>
      res.closed = true
      @end(res)
    @exec "tail", ["-f","-n","#{num}","/var/log/upstart/feel.log"],res,1200000, => @end res

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

  exec : (cmd,args,res,time,cb)=>
    t = new Date().getTime()

    unless cb?
      cb    = time
      time  = null
    @log res, "#{process.cwd()} $ "+cmd+" "+args.join(" ")+"\n"
    prog = spawn cmd, args
    prog.stdout.on 'data', (data)=> @log res,data
    prog.stderr.on 'data', (data)=> @log res,data
    prog.on 'close', (code)=>
      if false # time?
        nt = new Date().getTime()
        if nt-t<time
          return @exec cmd,args,res,time-(nt-t),cb
      cb()

    if time
      setTimeout =>
        prog.kill()
      , time




