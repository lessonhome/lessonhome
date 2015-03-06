

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
      @newFile(file).done()

    deferDirs = Q.defer()
    qsDirs = []
    @dbDirs.find().each (err,dir)=>
      qsDirs.push Q.reject err if err?
      return deferDirs.resolve Q.all qsDirs unless file?
      @dirs[dir.name] = new Dir dir
      @dirs[dir.name].init().done()
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
    qs.push Q.then => @dir(dir,false).then (d)=> d?.stat?()
    if stat.isFile()
      qs.push Q.then => @file(f,false).then (f)=> f?.stat?()
    else if stat.isDirectory() && f!=dir
      qs.push Q.then => @dir(f,false).then (d)=> d?.stat?()
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

  dir  : (name,create=true)=>
    yield @_unblock()
    name = _path.relative process.cwd(),_path.resolve name
    return @dirs[name] if @dirs[name]?
    return null unless create
    dir = new Dir name
    @dirs[name] = dir
    dir.init().done()
    return dir
  watch : ->



module.exports = WatcherMaster


