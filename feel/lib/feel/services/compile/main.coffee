
Sites = require './sites'

class Main
  init  : =>
    console.log "main:init"
    @sites = new Sites()
    @sites.init()
  run   : =>
    console.log "main:run"


module.exports = Main

