

_mime = require 'mime'


class SlaveDir
  constructor : (@conf)->
    Wrap @
    @_block()
  fixPath : (conf)=>
    if typeof conf == 'string'
      conf = path: _path.resolve "#{process.cwd()}/#{@conf}"
    if conf.path
      conf.dir = _path.relative process.cwd(),conf.path
    else
      if conf.dir
        conf.path = _path.resolve "#{process.cwd()}/#{conf.dir}"
      else
        throw new Error 'cant resolve path in config'+_inspect(conf)
    conf.pdir = _path.dirname   conf.dir
    conf.name = _path.basename  conf.dir
    return conf
  init :  (@master)=>
    @on 'deleted',@onDeleted
    @conf = yield @fixPath @conf
    @in   = {}
    @dir = {}
    for key,val of @conf
      @dir[key] = val
      @in[key]   = val
    yield @master.initDir @conf.dir
    @master.on 'change:dir:'+@conf.dir, =>
      @loadDb().done()
    yield @loadDb()
    yield @_block(false)
  delete : =>
    @emit 'deleted',@dir
  onDeleted : =>
    @_block()
    @_block false,new Error 'dir deleted',@dir.path
    yield @initDb()
    yield _invoke @db,'delete',path:@dir.path
  loadDb : =>
    yield @_single()
    yield @_block()
    yield @initDb()
    dirs = yield _invoke @db.find(dir:@dir.dir),'toArray'
    @dir = dirs[0]
    yield @_block(false)
    @emit 'change',@dir
  initDb : =>
    return if @db?
    db  = yield Main.serviceManager.nearest('db')
    @db = yield db.get 'watcherDirs'
  get :   =>
    yield @_unblock()
    return @dir

    

module.exports = SlaveDir





