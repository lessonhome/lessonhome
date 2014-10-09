
global.Q = require "q"
Q.longStackSupport = true
global.CLONE = require './lib/clone'

LoadSites = require './scripts/loadSites'
Server    = require './class/server/server'


class module.exports
  constructor : ->
    global.Feel = this
    @site = {}
    @path =
      www : "www"
    @init()
    .done()
  init : =>
    Q()
    .then LoadSites
    .then @createServer
  createServer : =>
    @server = new Server()
    Q().then @server.init
