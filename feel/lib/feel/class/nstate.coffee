


class _Sub
  constructor : (@p)->
  template : (name)=>
    name = @statename_resolve(name)
    unless @p.site.nstate[@statename_resolve(name)]?
      throw new Error "undefined state #{name} from state #{@p.name}::template"
    return @p.site.nstate[@statename_resolve(name)]
  statename_resolve : (str)=>
    throw new Error "bad statename #{str} from state #{@p.name}" unless typeof str == 'string'
    m = str.match /^\/(.*)$/
    return @statename_resolve m[1] if m
    m = str.match /^\.(.*)/
    if m
      return _path.normalize @p.dir+str
    return str

  exports : (name)=>
    if name && !(typeof name == 'string')
      throw new Error "bad exports #{_inspect(name)} from state #{@p.name}"
    return  {$exports:(name||"")}
  parent : => @p.object.extends
  top    : (obj=@p)=>
    return @top p if p = obj.parent()
    return obj
  getState : (name)=> @p.site.nstate[name]
class State
  constructor : (@site,@name)->
    @_sub = new _Sub @
    Wrap @
    @path = _path.normalize "#{process.cwd()}/#{@site.path.states}/#{@name}.coffee"
    @dir  = _path.normalize @name.match(/^(.*\/|)\w+$/)[1]
  init : =>
    @log "state\t\t".magenta+@name.cyan
    @file   = require @path
    throw new Error "bad class @main in state #{@name}" unless typeof @file?.main == 'function'
    @class  = @file.main
  tree : =>
    @object = Wrap new @class
    @object.extends = @_sub.template(@object.extends) if typeof @object.extends == 'string'
    @object.exports = @_sub.exports
    @object.state   = @f_state
    @object.module  = @f_module
    throw new Error "need function tree in state #{@name}" unless typeof @object?.tree=='function'
    @object.tree    = yield @object.tree()
    @object.tree.$states ?= {}
    @object.tree.$states[@name] = true

    yield _lookDown @object,'tree', Q.async (node,key,val)=>
      if Q.isPromise val
        node[key] = yield val
    console.log JSON.stringify @object.tree,2,2
  lookDown : =>
    yield _lookDown @object,'tree', Q.async (node,key,val)=>
      if val.$state
        s = @_sub.getState val.$state
        




  f_state : (name)=>
    throw new Error "bad statename #{_inspect(name)} from state #{@name}:state()" unless name
    switch typeof name
      when 'string' then data = {}
      when 'object'
        n = Object.keys(name)?[0]
        throw new Error "bad statename #{_inspect(name)} from state #{@name}:state()" unless n
        data = name[n]
        unless data && (typeof data=='object')
          throw new Error "bad data in @state(#{_inspect(name)}) from state #{@name}:state()"
        name = n
      else
        throw new Error "bad statename #{_inspect(name)} from state #{@name}:state()"
    data.$state = name
    return data
  f_module : (name)=>
    throw new Error "bad modulename #{_inspect(name)} from state #{@name}:module()" unless name
    switch typeof name
      when 'string' then data = {}
      when 'object'
        n = Object.keys(name)?[0]
        throw new Error "bad modulename #{_inspect(name)} from state #{@name}:module()" unless n
        data = name[n]
        unless data && (typeof data=='object')
          throw new Error "bad data in @module(#{_inspect(name)}) from state #{@name}:module()"
        name = n
      else
        throw new Error "bad modulename #{_inspect(name)} from state #{@name}:module()"
    data.$module = name
    return data
module.exports = State





