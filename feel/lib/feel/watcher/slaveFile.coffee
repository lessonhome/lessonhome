

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
    
    @master.on 'change:file:'+@conf.file, =>
      @loadDb().done()
    yield @loadDb()
    yield @_block(false)
  delete : =>
    @emit 'deleted',@file
  onDeleted : =>
    @_block()
    @_block false,new Error 'file deleted',@file.path
    yield @initDb()
    yield _invoke @db,'delete',path:@file.path
  loadDb : =>
    yield @_single()
    @log @file.file.yellow
    yield @_block()
    yield @initDb()
    files = yield _invoke @db.find(file:@file.file),'toArray'
    @log 'files'.yellow,files
    @file = files[0]
    @emit 'change',@file
    yield @_block(false)
  initDb : =>
    return if @db?
    db  = yield Main.serviceManager.nearest('db')
    @db = yield db.get 'watcherFiles'

  get :   =>
    yield @_unblock()
    return @file

    

module.exports = SlaveFile





