
coffee  = require 'coffee-script'
path    = require 'path'


class module.exports
  constructor : (@site,@name)->
    console.log "state #{@name}"
    @path       = "#{process.cwd()}/#{@site.path.states}/#{@name}.coffee"
    @state_dir  = @name.match(/^(.*\/|)\w+$/)[1]
    @inited = false
  init : =>
    @state_vars =
      module   : @function_module
      state    : @function_state
      extend   : @function_extend
      exports  : @function_export
      link     : ->
      parent   : {}
      site     : @site
      router   : @site.router
      urls     : @site.router.url
    _vars = @state_vars
    try
      state = coffee._compileFile @path
    catch e
      throw new Error "Failed compile state #{@name}:\n"+e
    @state = {}
    _state = @state
    state = "
      var state = _state;
      (function(){
        var module  = _vars.module;
        var state   = _vars.state;
        var extend  = _vars.extend;
        var exports = _vars.exports;
        var link    = _vars.link;
        var parent  = _vars.parent;
        var $site   = _vars.site;
        var $router = _vars.router;
        var $urls   = _vars.urls;
        var F       = (function (str){
          return \"/file/666/\"+str;
        });
        #{state}
      }).call(state);
      state
    "
    @state         = eval state
    @state.struct ?= {}
    @title = @name
    if @state.title?
      @title = @state.title
    @inited = true
  statename_resolve : (str)=>
    m = str.match /^\/(.*)$/
    return @statename_resolve m[1] if m
    m = str.match /^\.(.*)/
    if m
      return path.normalize @state_dir+str
    return str
  modulename_resolve : (str)=>
    str = str.replace /\$/g, @name
    m = str.match /^\.(.*)/
    if m
      return path.normalize @state_dir+str
    return str
  function_extend : (o)=>
    name = @statename_resolve o
    try
      @site.createState name
    catch e
      throw new Error "Failed compile state '#{o}':'#{name}' from state '#{@name}':\n"+e
    state = CLONE @site.state[name].state
    if @state.struct?
      console.error "extend(#{name}) error in state #{@name}, @struct already exists"
    @state.struct = state.struct
    @state.parent?= {}
    if state._export?
      for key,val of state._export
        @state.parent[key] = val
  function_export : (o)=>
    @state._export      ?= {}
    if typeof o == 'string'
      name = o
      @state._export[name] = {}
    else
      for key,val of o
        name = key
        @state._export[name] = val
    return @state._export[name]
  function_state  : (o)=>
    name = @statename_resolve o
    try
      @site.createState name
    catch e
      throw new Error "Failed compile state '#{o}':'#{name}' from state '#{@name}':\n"+e
    state = CLONE @site.state[name].state.struct
    return state
  function_module : (o)=>
    mod = {}
    mod._isModule   = true
    name = 'unknown'
    m    = {}
    switch typeof o
      when 'string'
        name = @modulename_resolve o
      when 'object'
        for key,val of o
          name  = @modulename_resolve key
          m     = val
      else
        throw new Error 'wrong module name', o
    mod._name  = name
    for key,val of m
      mod[key] = val
    if (!name.match(/^\/\/.*/)) && (!@site.modules[name]?)
      throw new Error "Can't find module '#{name}' in state '#{@name}'"
    return mod



