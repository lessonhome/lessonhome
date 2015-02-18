


class WatcherSlave
  constructor : ->
    Wrap @
  init : =>
    console.log 'slave init'
  watch : (foo)->

module.exports = WatcherSlave


