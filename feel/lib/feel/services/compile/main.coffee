
Sites = require './sites'

class Main
  init  : =>
    @sites = new Sites()
    @sites.init()
  run   : =>


module.exports = Main

