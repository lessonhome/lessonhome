


class WatcherSlave
  constructor : ->
    Wrap @
  init : =>
    @log()
  run : =>
    @master = yield Main.serviceManager.nearest 'watcherMaster'
  watch : (foo)->

module.exports = WatcherSlave


