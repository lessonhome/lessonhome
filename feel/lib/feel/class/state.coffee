
coffee = require 'coffee-script'

Module = (o)->
  mod = {}
  mod._isModule   = true
  name = 'unknown'
  m    = {}
  switch typeof o
    when 'string'
      name = o
    when 'object'
      for key,val of o
        name  = key
        m     = val
  mod._name  = name
  for key,val of m
    mod[key] = val
  console.log name, mod
  return mod

class module.exports
  constructor : (@site,@name)->
    @path = "#{process.cwd()}/#{@site.path.states}/#{@name}.coffee"
  init : =>
    state = coffee._compileFile @path
    console.log state
    state = "
      var state = {};
      (function(){
        var module = Module;
        #{state}
      }).call(state);
      state
    "
    @state = eval state



