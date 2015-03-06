

class Module
  constructor : (@name)->
    Wrap @
  init : =>
    @log @name

module.exports = Module


