


class MasterServiceManager
  constructor : ->
    Wrap @
    @config = {}
  init : =>
    configs = yield _readdir 'feel/lib/feel/service/config'
    for name in configs
      continue unless m = name.match /^(\w+)\.coffee$/
      @config[m[1]] = require "./config/#{name}"
      @config[m[1]].name = m[1]
  run  : =>




module.exports = MasterServiceManager



