

Sites = require './sites'

class Compile
  constructor : ->
    Wrap @
  init  : =>
    @sites = new Sites()
  run : =>
    yield @sites.init()
    @log 'init OK'.yellow
    yield @sites.run?()
    @log 'OK'.yellow


module.exports = Compile



