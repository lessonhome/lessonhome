


class Compile
  constructor : ->
    Wrap @
  init  : =>
  run : =>
    watcher       = yield Main.serviceManager.nearest 'watcher'
    db            = yield Main.serviceManager.nearest 'db'
    @db   = yield db.get 'compile'
module.exports = Compile



