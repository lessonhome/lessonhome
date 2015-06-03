


class _Sub
  constructor : (@p)->
  cdata : (data,lvl="",ret={})=>
    if data && (typeof data=='object')
      for key,val of data
        if (key.match /^\$\$/) || !(val && (typeof val == 'object'))
          ret[lvl+key] = val
        else
          @cdata val,lvl+key+".",ret
    return ret
  parent : => @p.object.extends
  top    : (obj=@p)=>
    return @top p if p = obj.parent()
    return obj
  getState : (name)=> @p.site.nstate[name]
class State
  constructor : (@site,@name)->
    @_sub = new _Sub @
    @cacheUse = {}
    Wrap @
    @path = _path.normalize "#{process.cwd()}/#{@site.path.states}/#{@name}.coffee"
    @dir  = _path.normalize @name.match(/^(.*\/|)\w+$/)[1]
  init : =>
    #@log "state\t\t".magenta+@name.cyan
    @file   = require @path
    throw new Error "bad class @main in state #{@name}" unless typeof @file?.main == 'function'
    @class  = @file.main
  tree : =>
    @object = Wrap new @class
    @object.exports = @exports
    @object.state   = @f_state
    @object.module  = @f_module
    @object.forms   = {}
    throw new Error "need function tree in state #{@name}" unless typeof @object?.tree=='function'
    tree    = yield @object.tree()
    @object.tree =
      $$exports : {}
      $$state  : [
        name    : @name
        node    : tree
      ]
      $$root   : tree
    #@object.tree.$states ?= {}
    #@object.tree.$states[@name] = true
    yield _lookDown @object,'tree', Q.async (node,key,val)=>
      if Q.isPromise val
        node[key] = yield val
    yield _lookDown @object,'tree', (node,key,val)=>
      if val?.$exports?
        exname = val.$exports || key
        @object.tree.$$exports[exname] ?= []
        arr = @object.tree.$$exports[exname]
        o   = {}
        o.node = node
        o.key  = key
        arr.push o
  use : (data={},saveCache = false)=>
    if saveCache
      saveCache = _shash JSON.stringify data if saveCache == true
      return _clone @cacheUse[saveCache] if @cacheUse?[saveCache]?
    yield @treeExtend() if @object.extends == 'string'
    tree = _clone @object.tree
    for key,val of data
      unless tree.$$exports?[key]?
        throw new Error "unknown exports name #{key} in state #{@name}"
      for o in tree.$$exports[key]
        o.node[o.key] = val
      delete tree.$$exports[key]
    if tree?.$$exports
      for key,val of tree?.$$exports
        for o in val
          delete o.node[o.key]
      delete tree.$$exports
    yield @treeStateResolve tree
    if saveCache
      @cacheUse[saveCache] = tree
    return tree
    
  treeExtend : =>
    return unless typeof @object.extends == 'string'
    @object.extends = yield @template(@object.extends)
    tree = yield @object.extends.use @object.tree.$$root,true
    @object.tree.$$root = tree.$$root
    @object.tree.$$state.push tree.$$state...
    @object.extends = undefined
  treeStateResolve : (root)=>
    _lookDown root.$$state[0],'node', Q.async (node,key,val)=>
      return unless val.$state
      state = yield @template(val.$state.name)
      tree = yield state.use val.$state.data,true #_clone state.object.tree
      node[key] = tree
      return
    
  template : (name)=>
    name = yield @statename_resolve(name)
    unless @site.nstate[yield @statename_resolve(name)]?
      throw new Error "undefined state #{name} from state #{@name}::template"
    return @site.nstate[yield @statename_resolve(name)]
  statename_resolve : (str)=>
    throw new Error "bad statename #{str} from state #{@name}" unless typeof str == 'string'
    m = str.match /^\/(.*)$/
    return @statename_resolve m[1] if m
    m = str.match /^\.(.*)/
    return _path.normalize @dir+str if m
    return str
  exports : (name)=>
    if name && !(typeof name == 'string')
      throw new Error "bad exports #{_inspect(name)} from state #{@name}"
    return  {$exports:(name||"")}
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
    #data.$state = name
    return {
      $state :
        name : name
        data : data
    }
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
    #data.$module = name
    return {
      $module :
        name : name
        data : data
    }
module.exports = State





