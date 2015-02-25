
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
    yield @processManager.run?()
    yield @serviceManager.run?()
    @log 'INITED'
module.exports = Main

