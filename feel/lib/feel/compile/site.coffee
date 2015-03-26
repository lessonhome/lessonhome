

Module = require './module'
State  = require './state'


class Site
  constructor : (@name)->
    Wrap @
    @module = {}
    @state  = {}
    @path   =
      modules : "www/#{@name}/modules"
      states  : "www/#{@name}/states"
  init : =>
    @watcher = yield Main.service 'watcher'
    qs = []
    qs.push @findModules @watcher.dir @path.modules
    qs.push @findStates  @watcher.dir @path.states
    Q.all qs
  run : =>
    runObj = _qlimit 8,@runObj
    qs = []
    for name,module of @module
      qs.push runObj module
    yield Q.all qs
    qs = []
    for name,state of @state
      qs.push runObj state
    yield Q.all qs
  runObj : (obj)=> obj.run?()
  findModules : (qdir)=>
    dirs    = (yield (yield qdir).get()).dirs
    qs = []
    for dir in dirs
      qs.push @findModules @watcher.dir dir
    for dir in dirs
      name = _path.relative @path.modules,dir
      module = new Module name,@
      @module[name] = module
      qs.push module.init()
    Q.all qs
  initDb : =>
    db = yield Main.service 'db'
    @db = yield db.get 'feel-sites'
  findStates  : =>


module.exports = Site
