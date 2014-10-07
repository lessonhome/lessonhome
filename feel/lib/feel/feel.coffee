
global.Q = require "q"
Q.longStackSupport = true

Start = require './start'

class module.exports
  constructor : ->
    global.Feel = this
    @site = {}
    @path =
      www : "www"
    @init()
  init : =>
    Q(@)
    .then Start
