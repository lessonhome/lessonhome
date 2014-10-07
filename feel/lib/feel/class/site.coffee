
State = require './state'
readdir = Q.denodeify require('fs').readdir

class module.exports
  constructor : (@sitename)->
    @path         = {}
    @path.root    = "#{Feel.path.www}/#{@sitename}"
    @path.src     = "#{@path.root}/src"
    @path.states  = "#{@path.src}/states"
    @state = {}

  init : =>
    console.log 'init', @sitename
    Q()
    .then @loadStates
    .done()
  loadStates : =>
    readdir @path.states
    .then (names)=>
      for name in names
        name = name.match(/^(.*)\.\w+$/)[1]
        @state[name] = new State @, name
      names.reduce (promise,statename)=>
        promise.then @state[name].init
      , Q()
