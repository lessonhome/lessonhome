
MasterProcessManager = require './process/masterProcessManager'

class Main
  constructor : ->
    Wrap @
  init : =>
    @processManager = new MasterProcessManager()
    yield @processManager.init()

module.exports = Main

