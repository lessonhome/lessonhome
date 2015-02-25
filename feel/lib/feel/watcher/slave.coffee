


class WatcherSlave
  constructor : ->
    Wrap @
  init : =>
    @log()
  run : =>
    @master = yield Main.serviceManager.nearest 'watcherMaster'
    @log Object.keys @master
    @log yield @master.watch 'watch'
    return 
    #@log yield @master.watch "watch me "+Main.processId
  watch : (foo)->

module.exports = WatcherSlave


