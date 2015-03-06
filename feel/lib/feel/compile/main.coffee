


class Compile
  constructor : ->
    Wrap @

  init  : =>
  run : =>
    watcher       = yield Main.serviceManager.nearest 'watcher'
    db            = yield Main.serviceManager.nearest 'db'
    @db = yield db.get 'compile'
    file = yield watcher.file 'run.sh'


module.exports = Compile



