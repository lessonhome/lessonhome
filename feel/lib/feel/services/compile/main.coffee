
Sites = require './sites'

class Main
  init  : =>
    Wrap @
    Log "main:init"
    @sites = new Sites()
    @sites.init()
  run   : =>
    Log "main:run"


module.exports = Main

