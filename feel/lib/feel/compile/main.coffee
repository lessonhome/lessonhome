


class Compile
  constructor : ->
    Wrap @

  init : =>
  run : =>
    watcher       = yield Main.serviceManager.nearest 'watcher'
    watcherMaster = yield Main.serviceManager.nearest 'watcherMaster'
    db            = yield Main.serviceManager.nearest 'db'
    #@log  Object.keys watcher
    #@log  Object.keys watcherMaster
    #@log  Object.keys db



module.exports = Compile



