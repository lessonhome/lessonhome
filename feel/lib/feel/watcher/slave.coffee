

File = require './slaveFile'

class WatcherSlave
  constructor : ->
    Wrap @
    @_block()
    @files = {}
    @dirs  = {}
  init : =>
    @log()
  run : =>
    @master = yield Main.serviceManager.nearest 'watcherMaster'
    yield @_block false
  file : (name,create=true)=>
    yield @_unblock()
    name = _path.relative process.cwd(), _path.resolve name
    return @files[name] if @files[name]?
    return null unless create
    file = new File name
    @files[name] = file
    yield file.init @master
    return file
 
  dir  : (name)=>
    yield @_unblock()

module.exports = WatcherSlave


