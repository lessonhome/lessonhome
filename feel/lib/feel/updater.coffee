

http  = require 'http'
os    = require 'os'
spawn = require('child_process').spawn
ps    = require 'ps-node'


class module.exports
  constructor : ->
    @port = 8888
  run : ->
    #return if os.hostname() != 'pi0h.org'
    @server = http.createServer @handler
    @hand = 0
    @server.listen @port

  handler :(req,res)=>
    return res.end() if req.url != "/update.txt"
    @hand++
    res.setHeader 'x-content-type-options', 'nosniff'
    res.setHeader 'Connection', 'Transfer-Encoding'
    res.setHeader 'Content-Type', 'text/plain; charset=utf-8'
    res.setHeader 'Transfer-Encoding', 'chunked'

    @exec "git", ["pull"], res, =>
      process.chdir 'feel'
      @exec "npm",["i"],res, =>
        process.chdir '..'
        ps.lookup {
          command : 'node'
          psargs : "aux"
        }, (err,list)=>
          boo = false
          if !err
            for p in list
              for a in p.arguments
                if a.match /feel.bin.feel$/
                  @log res,"kill "+p.pid
                  @exec "tail", ["-f","/var/log/upstart/feel.log"],res,60000, => @end res
                  ps.kill p.pid, =>
                  boo = true

          if !boo
            @log res, "Can't find process node:feel!\n"
            @end res


  end : (res)=>
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




