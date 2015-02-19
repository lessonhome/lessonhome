


class WatcherMaster
  constructor : ->
    Wrap @
  init : =>
    console.log 'master init'
  watch : (foo)->

module.exports = WatcherMaster


