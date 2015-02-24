
MasterProcessManager = require './process/masterProcessManager'
MasterServiceManager = require './service/masterServiceManager'

class Main
  constructor : ->
    Wrap @
  init : =>
    @serviceManager = new MasterServiceManager()
    @processManager = new MasterProcessManager()
    yield @serviceManager.init()
    yield @processManager.init()
    yield @processManager.run?()
    yield @serviceManager.run?()

module.exports = Main

