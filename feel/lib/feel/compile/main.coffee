

Sites = require './sites'

class Compile
  constructor : ->
    Wrap @
  init  : =>
    @sites = new Sites()
  run : =>
    yield @sites.init()


module.exports = Compile



