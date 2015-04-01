

http  = require 'http'
os    = require 'os'
spawn = require('child_process').spawn
ps    = require 'ps-node'


class module.exports
  constructor : ->
    @port = 8888
    @updating = false
  run : ->
    #return if os.hostname() != 'pi0h.org'
    @server = http.createServer @handler
    @hand = 0
    @server.listen @port
  handler :(req,res)=>
    return process.exit(0) if req.url == "/restart"
    return @tail(req,res) if req.url != "/update"

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
          command : 'node'
          psargs : "aux"
        }, (err,list)=>
          @exec "cat", ["./feel/version"], res, =>
            if !err
              for p in list
                for a in p.arguments
                  if a.match /feel.bin.feel$/
                    @log res,"#{process.cwd()} $ kill "+p.pid+"\n"
                    @exec "tail", ["-f","-n","0","/var/log/upstart/feel.log"],res,600000, => @end res
                    ps.kill p.pid, =>
                    boo = true

            if !boo
              @log res, "Can't find process node:feel!\n"
              @end res
  tail : (req,res)=>
    res.on 'close', =>
      res.closed = true
      @end(res)
    @exec "tail", ["-f","-n","30","/var/log/upstart/feel.log"],res,1200000, => @end res

  end : (res)=>
    return if res.closed
    res.end "====================================="
    @hand--
    if @hand <= 0
      process.exit()
  log : (res,msg)=>
    res.write msg
    process.stdout.write msg

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




