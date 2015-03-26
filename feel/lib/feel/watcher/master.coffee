

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
      db.get 'feel-watcherFiles'
      db.get 'feel-watcherDirs'
    ]
    deferFiles = Q.defer()
    qf = []
    nfile = _qlimit 40,@newFile
    @dbFiles.find().each (err,file)=>
      return qsFiles.push Q.reject err if err?
      return deferFiles.resolve Q.all qf unless file?
      qf.push nfile file
    deferDirs = Q.defer()
    qd = []
    ndir = _qlimit 40,@newDir
    @dbDirs.find().each (err,dir)=>
      return deferDirs.reject err if err?
      return deferDirs.resolve Q.all qd unless dir?
      qd.push ndir dir
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
    yield @dirs[conf.dir].init(@)
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


