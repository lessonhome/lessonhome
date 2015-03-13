

_mime = require 'mime'


class SlaveFile
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
  init :  (@master)=>
    @on 'deleted',@onDeleted
    @conf = yield @fixPath @conf
    @in   = {}
    @file = {}
    for key,val of @conf
      @file[key] = val
      @in[key]   = val
    @_ready      = false
    @_readyHash  = false
    @_masterInit = false
    @complite = false
    yield @master.initFile @conf.file
    @master.on 'change:file:'+@conf.file, =>
      @loadDb().done()
    yield @loadDb()
    yield @_block(false)
  ready : =>
    @complite = true
    yield @_single()
    return if @_ready
    yield @loadDb()
    @_ready     = true
    @_readyHash = true
  readyHash : =>
    yield @_single()
    return if @_readyHash
    yield @loadDb
    @_readyHash = true
  masterInit : =>
    yield @_single()
    return if @_masterInit
    yield @master.initFile @conf.file
    @_masterInit = true
  delete : =>
    @emit 'deleted',@file
  onDeleted : =>
    @_block()
    @_block false,new Error 'file deleted',@file.path
    yield @initDb()
    yield _invoke @db,'delete',path:@file.path
  loadDb : =>
    yield @_single()
    yield @_block()
    #yield @masterInit()
    yield @initDb()
    #if @complite
    files = yield _invoke @db.find(file:@file.file),'toArray'
    #else
    # files = yield _invoke @db.find({file:@file.file},{hash:1,file:1,path:1,ext:1,name:1}),'toArray'
    @file = files[0]
    yield @_block(false)
    @emit 'change',@file
  initDb : =>
    return if @db?
    db  = yield Main.serviceManager.nearest('db')
    @db = yield db.get 'feel-watcherFiles'

  get :   =>
    yield @_unblock()
    #yield @ready()
    return @file
  getHash :   =>
    yield @_unblock()
    #yield @ready()
    return @file.hash

    

module.exports = SlaveFile





