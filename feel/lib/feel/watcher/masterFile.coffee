

_mime = require 'mime'


class MasterFile
  constructor : (@conf)->
    Wrap @
    @_block().done()
  fixPath : =>
    conf = @conf
    if typeof conf == 'string'
      conf = path: _path.resolve "#{process.cwd()}/#{conf}"
    if conf.path
      conf.file = _path.relative process.cwd(),conf.path
    else
      if conf.file
        conf.path = _path.resolve "#{process.cwd()}/#{conf.file}"
      else
        throw new Error 'cant resolve path in config'+_inspect(conf)
    conf.dir  = _path.dirname   conf.file
    conf.base = _path.basename  conf.file
    conf.ext  = _path.extname   conf.file
    conf.name = _path.basename  conf.file,conf.ext
    conf.mime = _mime.lookup conf.file
    return @conf = conf
  init :  =>
    @on 'deleted',@onDeleted
    
    yield @fixPath()
    @in   = {}
    @file = {}
    for key,val of @conf
      @file[key] = val
      @in[key]   = val
    if @file.ready
      @log @file.file,'from db'.yellow
      @_block(false)
    @stat().done()

  stat : =>
    yield @_single()
    @log 'stat',@file.file.red
    @file.exists = yield _exists @file.path
    return @delete() unless @file.exists
    @file.stat   = yield _stat   @file.path
    delete @file.stat.atime
    delete @file.stat.ino
    
    statHash = _shash _inspect @file.stat
    return if @file.statHash == statHash
    @_block()
    @file.statHash = statHash
    src   = yield _readFile @file.path
    hash  = _shash src
    if hash != @file.hash
      @file.hash = hash
      @file.src  = src
    @file.ready = true
    @log @file.file,'from system'.yellow
    @_block(false)
    yield @updateDb()

  delete : =>
    @emit 'deleted',@file
  onDeleted : =>
    @_block()
    @_block false,new Error 'file deleted',@file.path
    yield @initDb()
    yield _invoke @db,'delete',path:@file.path

  updateDb  : =>
    yield @_single()
    _file = @file
    _in   = @in
    update = false
    for key,val of _file
      if val != _in[key]
        update = true
    return unless update
    @in = {}
    for key,val of _file
      @in[key] = val
    @log 'update db'.yellow,_file.file
    yield @initDb()
    yield _invoke @db,'update',{path:_file.path},{$set:_file},{upsert:true}
    @emit 'change',@file
  initDb : =>
    return if @db?
    db  = yield Main.serviceManager.nearest('db')
    @db = yield db.get 'watcherFiles'

  get :   =>
    yield @_unblock()
    return @file

    

module.exports = MasterFile





