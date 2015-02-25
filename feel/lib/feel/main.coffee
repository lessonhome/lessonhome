
MasterProcessManager = require './process/masterProcessManager'
MasterServiceManager = require './service/masterServiceManager'

class Main
  constructor : ->
    @name = 'Master'
    Wrap @
  init : =>
    @log()
    @serviceManager = new MasterServiceManager()
    @processManager = new MasterProcessManager()
    yield @serviceManager.init()
    yield @processManager.init()
    yield @serviceManager.run?()
    yield @processManager.run?()
    @log 'OK'
module.exports = Main

