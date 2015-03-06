

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
    yield Q.all qs
  findModules : (qdir)=>
    qs = []
    dirs    = (yield (yield qdir).get()).dirs
    for dir in dirs
      qs.push @findModules @watcher.dir dir
    for dir in dirs
      name = _path.relative @path.modules,dir
      module = new Module name
      @module[name] = module
      qs.push module.init()
    Q.all qs
  findStates  : =>

  


module.exports = Site



