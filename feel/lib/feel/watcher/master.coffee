

_watch  = require 'watch'
_createMonitor = Q.rdenode (args...)-> _watch.createMonitor args...

File = require './masterFile'
Dir  = require './masterDir'

class WatcherMaster
  constructor : ->
    Wrap @
    @files  = {}
    @dirs   = {}
    @_block()
  init : =>
    @log()
  run : =>
    db  = yield Main.serviceManager.nearest('db')
    [@dbFiles,@dbDirs] = yield Q.all [
      db.get 'watcherFiles'
      db.get 'watcherDirs'
    ]
    deferFiles = Q.defer()
    qsFiles = []
    @dbFiles.find().each (err,file)=>
      qsFiles.push Q.reject err if err?
      return deferFiles.resolve Q.all qsFiles unless file?
      qsFiles.push @newFile(file)

    deferDirs = Q.defer()
    qsDirs = []
    mq = Q()
    I = 0
    @dbDirs.find().each (err,dir)=>
      #qsDirs.push Q.reject err if err?
      deferDirs.reject err if err?
      unless dir?
        return deferDirs.resolve mq
        console.log 'unless'
        console.log qsDirs.length
        nq = Q()
        for q,i in qsDirs
          do (i,q)=>
            nq = nq.then =>
              console.log 'start',i
              return q
            .then =>
              console.log 'done',i
        deferDirs.resolve nq.then -> console.log 'resolved'
        console.log 'ok'
        return
      console.log dir.dir.red
      i_ = I++
      #qsDirs.push  Q().then => @newDir(dir)
      mq = mq.then =>
        console.log 'start', i_
      .then =>
        @newDir dir
      .then =>
        console.log 'done', i_
    yield Q.all [deferFiles.promise,deferDirs.promise]
    @_block(false)
    @createMonitor().done()
  createMonitor : =>
    @monitor = yield _createMonitor './'
    @monitor.on 'created',@mcreated
    @monitor.on 'changed',@mchanged
    @monitor.on 'removed',@mremoved
  mcreated : (f,stat)=>
    delete stat.atime
    dir = _path.dirname f
    qs = []
    qs.push Q.then => @dir(dir,false).then (d)=> d?.stat?()
    if stat.isFile()
      qs.push Q.then => @file(f,false).then (f)=> f?.stat?()
    else if stat.isDirectory() && f!=dir
      qs.push Q.then => @dir(f,false).then (d)=> d?.stat?()
    Q.all qs
  mchanged : (f,stat,pstat)=>
    delete stat.atime
    delete pstat.atime
    dir = _path.dirname f
    qs = []
    qs.push Q.then => @dir(dir,false).then (d)=> d?.stat?()
    if stat.isFile()
      qs.push Q.then => @file(f,false).then (f)=> f?.stat?()
    else if stat.isDirectory() && f!=dir
      qs.push Q.then => @dir(f,false).then (d)=> d?.stat?()
    Q.all qs

  mremoved : (f,stat)=>
    delete stat.atime
    dir = _path.dirname f
    qs = []
    qs.push Q.then    => @dir(dir,false).then (d)=> d?.stat?()
    if stat.isFile()
      qs.push Q.then  =>@file(f,false).then (f)=> f?.stat?()
    else if stat.isDirectory() && f!=dir
      qs.push Q.then  => @dir(f,false).then (d)=> d?.stat?()
    Q.all qs
    
  file : (name,create=true)=>
    yield @_unblock()
    name = _path.relative process.cwd(), _path.resolve name
    return @files[name] if @files[name]?
    return null unless create
    return @newFile name
  newFile : (conf)=>
    if typeof conf=='string'
      conf = file: _path.relative process.cwd(), _path.resolve(conf)
    file = new File conf
    file.on 'change', =>
      @emit 'change:file:'+conf.file
    file.on 'deleted', =>
      @emit 'deleted:file:'+conf.file
     
    @files[conf.file] = file
    @files[conf.file].init().done()
    return Q(file)
  dir : (name,create=true)=>
    yield @_unblock()
    name = _path.relative process.cwd(), _path.resolve name
    return @dirs[name] if @dirs[name]?
    return null unless create
    return @newDir name
  newDir : (conf)=>
    if typeof conf=='string'
      conf = dir: _path.relative process.cwd(), _path.resolve(conf)
    dir = new Dir conf
    dir.on 'change', =>
      @emit 'change:dir:'+conf.dir
    dir.on 'deleted', =>
      @emit 'deleted:dir:'+conf.dir
      
    @dirs[conf.dir] = dir
    console.log conf.dir
    yield @dirs[conf.dir].init(@)
    console.log 'inited'
    return dir
  initFile : (name)=>
    f = yield @file(name)
    yield f.get()
    return true
  initDir : (name)=>
    f = yield @dir(name)
    yield f.get()
    return true
  watch : ->



module.exports = WatcherMaster


