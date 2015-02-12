
_fs       = require 'fs'
_readdir  = Q.denode _fs.readdir



class MasterManager
  constructor : ->
    Wrap @
    @config = {}
  init : =>
    configs = yield _readdir 'config'
    @config[name] = require("./#{name}") for name in configs
    



module.exports = MasterManager


