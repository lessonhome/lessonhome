


class Compile
  constructor : ->
    Wrap @

  init  : =>
  run : =>
    watcher       = yield Main.serviceManager.nearest 'watcher'
    watcherMaster = yield Main.serviceManager.nearest 'watcherMaster'
    db            = yield Main.serviceManager.nearest 'db'
    @db = yield db.get 'compile'



module.exports = Compile



