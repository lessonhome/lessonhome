

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
      @files[file.file] = new File file
      @files[file.file].init().done()

    deferDirs = Q.defer()
    qsDirs = []
    @dbDirs.find().each (err,dir)=>
      qsDirs.push Q.reject err if err?
      return deferDirs.resolve Q.all qsDirs unless file?
      @dirs[dir.name] = new Dir dir
      @dirs[dir.name].init().done()
    yield Q.all [deferFiles,deferDirs]
    @_block(false)
    @log _inspect yield (yield @file('run.sh')).get()
  file : (name)=>
    yield @_unblock()
    name = _path.relative process.cwd(), _path.resolve name
    return @files[name] if @files[name]?
    file = new File name
    @files[name] = file
    file.init().done()
    return file
  dir  : (name)=>
    yield @_unblock()
    name = _path.relative process.cwd(),_path.resolve name
    return @dirs[name] if @dirs[name]?
    dir = new Dir name
    @dirs[name] = dir
    dir.init().done()
    return dir


  watch : (foo)->

module.exports = WatcherMaster


