

_mime = require 'mime'


class MasterDir
  constructor : (@conf)->
    Wrap @
    @_block()
  fixPath : (conf)=>
    if typeof conf == 'string'
      conf = path: _path.resolve "#{process.cwd()}/#{@conf}"
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
    return conf
  init :  =>
    return
    @on 'deleted',@onDeleted
    @conf = yield @fixPath @conf
    @in   = {}
    @file = {}
    for key,val of @conf
      @file[key] = val
      @in[key]   = val
    @_block(false) if @file.ready
    @stat().done()

  stat : =>
    @file.exists = yield _exists @file.path
    return @delete() unless @file.exists
    @file.stat   = yield _stat   @file.path
    delete @file.stat.atime
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
    @emit 'change',_file
    @log 'TODO update function'.yellow
    yield @initDb()
    yield _invoke @db,'update',{path:_file.path},{$set : _file},{upsert : true}
  initDb : =>
    return if @db?
    db  = yield Main.serviceManager.nearest('db')
    @db = yield db.get 'watcherFiles'

  get :   =>
    yield @_unblock()
    return @file
    

module.exports = MasterDir





