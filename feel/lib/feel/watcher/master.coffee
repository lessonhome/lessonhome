


class WatcherMaster
  constructor : ->
    Wrap @
  init : =>
    @log()
  run : =>
    db  = yield Main.serviceManager.nearest('db')
    @db = yield db.get 'watcher'
  watch : (foo)->
    @log foo
    return 'ok'

module.exports = WatcherMaster


