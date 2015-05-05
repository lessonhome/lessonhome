

coffee  = require 'coffee-script'
path    = require 'path'

fs      = require 'fs'

class module.exports
  constructor : (@site,@name)->
    @path     = "#{process.cwd()}/#{@site.path.states}/#{@name}.coffee"
    @dir      = @name.match(/^(.*\/|)\w+$/)[1]
    @inited   = false
    @sdepend  = {}
    
  init : =>
    #return unless @name.match(/^test.*/) || @name.match(/^dev.*/)
    console.log "state\t\t".magenta, "#{@name}".cyan
    try
      src = coffee._compileFile @path
    catch e
      console.error Exception e
      throw new Error "Failed compile satate #{@name}"
    
    context = [
      'module'
      'state'
      'template'
      'exports' # fix module.exports to undefined, use @exports instead
      'extend'
      'data'
      'F'
    ]
    that = @

    @src  = "var file = {};
            (function(){"

    for f in context
      @src += " var #{f} = that.function_#{f};"
    @src += " var $urls   = that.site.router.url,
                  $router = that.site.router,
                  $site   = that.site,
                  $db     = that.site.db;"
    @src += src
    @src += "
      if (this.main && this.main.prototype && this.main.prototype.tree){
      var __oldtree = this.main.prototype.tree;
      this.main.prototype.tree = function(){
          var that = this;
          "
          
    for f in context
      @src += "
      var __old#{f} = #{f};
          #{f} = function(){
            return __old#{f}.call.apply(__old#{f}, [that].concat([].slice.call(arguments), [that]));
          };
          "
    @src +="
          return __oldtree.call.apply(__oldtree, [that].concat([].slice.call(arguments)));
      };}
    "
    @src += " }).call(file); file"
    @makeClass()
  makeClass : =>
    that = @
    try
      src = eval @src
    catch e
      console.error Exception e
      throw new Error "Failed exec state #{@name} "+e
    return unless src.main?
    throw new Error "Not defined 'class @main' in state '#{@name}'" unless src.main?
    
    @class = src.main
    @class::__make = => @make.apply @, arguments
    @class::__bind_exports = => @bind_exports.apply @, arguments
    @class::statename = @name
    @checkFoo 'init'
    @checkFoo 'run'
    @checkFoo 'tree', -> {}
    @checkVar 'route'
    @checkVar 'model'
    @inited = true
    if @class::route? && !@name.match(/^(dev|test)/)
      throw new Error "Undefined title in state '#{@name}'" unless @class::title?
      throw new Error "Undefined model in state '#{@name}'" unless @class::model?
      if @class::model
        file = "#{@site.path.src}static/models/#{@class::model}.jpg"
        throw new Error "can't find model file '#{file}' for model #{@class::model} in state #{@name}" unless fs.existsSync file
  checkFoo : (name,foo)=>
    foo ?= ->
    if @class::constructor?.__super__?[name]?
      if @class::[name] == @class::constructor.__super__[name]
        @class::[name] = foo
  checkVar : (name,foo)=>
    if @class::constructor?.__super__?[name]?
      if @class::[name] == @class::constructor.__super__[name]
        @class::[name] = foo

  make           : (o,state,...,req,res)=> do Q.async =>
    @makeClass()
    state         ?= new @class()
    req._smart = true
    res._smart = true
    state.req = req
    state.res = res
    state._smart  = true
    state.exports = (name='{{NULL}}')=> __exports:name
    state.name = @name
    tree = state.tree()
    tree.__state      = state
    tree._isState     = true
    tree._statename   = @name
    tree.__states ?= {}
    __states = tree.__states
    __states[@name] = state
    #tree.__states.push state
    for key,val of tree
      state.tree[key] = val
    if (state.tags?) && ( typeof state.tags != 'function')
      tags_ = state.tags
      state.tags = -> tags_
    state.tag = state.tags?()
    if typeof state.tag == 'string'
      state.tag = [state.tag]
    else if !state.tag?.length?
      state.tag = []
    state.access ?= []
    state.access = state.access() if typeof state.access =='function'
    state.access ?= []
    if typeof state.access == 'string'
      state.access = [state.access]
    state.redirect ?= {}
     

    temp = {}
    #state.page_tags ?= {}
    for tag in state.tag
      if typeof tag == 'string'
        temp[tag] = true
        #state.page_tag[tag] = true
    state.tag = temp
    cont = true
    qs = []
    while cont
      cont = false
      @walk_tree_down state.tree, (node,key,val)=>
        if Q.isPromise val
          cont = true
          qs.push val.then (ret)=>
            #console.log 'data stop'.red
            node[key] = ret
      yield Q.all qs


    unless state.tree._isModule
      for key,val of state.tree
        if val._isModule
          if val.__state?
            state.tree.__states ?= {}
            for k,v of val.__state.tree.__states
              state.tree.__states[k] = v
          val.__state = state
          #val.__states.push state
          val._isState = true
          val._statename = @name
    try
      do (state)=>
        @walk_tree_down state.tree, (node,key,val)=>
          if val?.__state?
            s = val.__state
          if val.__exports?
            name = val.__exports
            if name == '{{NULL}}'
              name = key
              delete node[key]
            else if typeof name == 'object'
              for key,val of name
                name = key
                node[key] = val
                break
            else if typeof name == 'string'
              delete node[key]
            state.exports[name] ?= []
            state.exports[name].push {
              node
              key
            }
    catch e
      console.error "failed match exports in state #{@name}", Exception e
      throw e
    @bind_exports state,o
    try
      if state.constructor.__super__?
        state.parent = state.constructor.__super__
        
        yield state.parent.__make null,state.parent,req,res
        _p = state.parent
        _n = state
        while _p
          _p.tree.__states ?= {}
          for k,v of _n.tree.__states
            _p.tree.__states[k] = v
          ###
          unless _p.tree._isModule
            for key,val of _p.tree
              if val._isModule
                if val.__state?
                  for k,v of val.__state.tree.__states
                    _p.tree.__states[k] = v
          ###
          #val.__state = state
          _n = _p
          _p = _p.constructor.__super__

    catch e
      console.error "failed make parent in state #{@name}",Exception(e),state.parent
      throw e
    if state.parent
      state.parent.__bind_exports state.parent, state.tree
    try
      yield state.init?()
      cont  = true
      qs    = []
      while cont
        cont = false
        @walk_tree_down state.tree, (node,key,val)=>
          if Q.isPromise val
            cont = true
            qs.push val.then (ret)=> node[key] = ret
        yield Q.all qs
    catch e
      console.error "failed state init #{@name}",Exception e
      throw e
    osdepend = {}
    for name of @sdepend
      for key of @site.state[name].sdepend
        osdepend[key] = true
    for key of osdepend
      @sdepend[key] = true
    return state
  bind_exports : (state,o)=>
    try
      if typeof o == 'object' || typeof o == 'function'
        for key,val of o
          continue if key.match /^_/
          if !state.exports[key]?
            console.error "can't find exports name '#{key}' in state #{@name}"
          else
            for exp in state.exports[key]
              node = exp.node
              k    = exp.key
              if typeof node[k] == 'object' || typeof node[k]=='function'
                for a,b of val
                  node[k][a] = b
              else node[k] = val
              if node == state.tree
                if state.parent?.exports?[k]?
                  newo = {}
                  newo[k] = node[k]
                  state.parent.__bind_exports state.parent, newo
    catch e
      console.error "failed merge tree in state #{@name} with object", o,Exception e
      throw e
    
  walk_tree_up : (node, foo)=>
    if (typeof node == 'object' || typeof node == 'function') && !node?._smart
      for key,val of node
        @walk_tree_up node[key],foo
        foo node,key,val
  walk_tree_down : (node,foo)=>
    if (typeof node == 'object' || typeof node == 'function') && !node?._smart
      for key,val of node
        foo node,key,val if val?
      for key,val of node
        @walk_tree_down node[key],foo
  statename_resolve : (str)=>
    m = str.match /^\/(.*)$/
    return @statename_resolve m[1] if m
    m = str.match /^\.(.*)/
    if m
      return path.normalize @dir+str
    return str
  modulename_resolve : (str)=>
    str = str.replace /\$/g, @name
    m = str.match /^\.(.*)/
    if m
      return path.normalize @dir+str
    return str
  function_state  : (o,...,state)=> do Q.async =>
    if typeof o == 'string'
      name = @statename_resolve o
      o = null
    else if typeof o == 'object' || typeof o == 'function'
      name = ''
      for key,val of o
        if name != ''
          console.error 'wrong statename in ', o, " from state #{@name}"
          throw new Error 'wrong statename'
        name = key
      if name == ''
        console.error 'wrong statename in ', o, " from state #{@name}"
        throw new Error 'wrong statename'
      o = o[name]
      name = @statename_resolve name
    try
      @site.createState name
      @sdepend[name] = true
      state = yield @site.state[name].make o,null,state.req,state.res
      tree = {}
      for key,val of state.tree
        tree[key] = val
      return tree
    catch e
      throw new Error "Failed make state '#{o}':'#{name}' from state '#{@name}':\n"+e
  function_template  : (o,...,state)=>
    if typeof o == 'string'
      name = @statename_resolve o
      o = null
    else if typeof o == 'object' || typeof o == 'function'
      name = ''
      for key,val of o
        if name != ''
          console.error 'wrong statename in ', o, " from state #{@name}"
          throw new Error 'wrong statename'
        name = key
      if name == ''
        console.error 'wrong statename in ', o, " from state #{@name}"
        throw new Error 'wrong statename'
      o = o[name]
      name = @statename_resolve name
    try
      @site.createState name
      @sdepend[name] = true
      return @site.state[name].class
    catch e
      throw new Error "Failed make state '#{o}':'#{name}' from state '#{@name}':\n"+e
  function_module : (o,...,state)=>
    mod = {}
    mod._isModule   = true
    name = 'unknown'
    m    = {}
    switch typeof o
      when 'string'
        name = @modulename_resolve o
      when 'object', 'function'
        for key,val of o
          name  = @modulename_resolve key
          m     = val
      else
        throw new Error 'wrong module name', o
    lastn = name
    arr = name.split(':')
    name = arr.shift()
    mod._name  = name
    for ext,i in arr
      arr[i] = path.normalize "#{name}/#{ext}"
      if !@site.modules[arr[i]]?
        throw new Error "extends module '#{arr[i]}' not exists in state:#{@name}::#{lastn}".red

    mod._extends_modules = arr
    for key,val of m
      mod[key] = val
    if (!name.match(/^\/\/.*/)) && (!@site.modules[name]?)
      throw new Error "Can't find module '#{name}' in state '#{@name}'"
    return mod

  function_F : (f,...,state)=> Feel.static.F @site.name,f
  function_extend : ()=> {}
  function_data : (s,...,state)=>
    ha = _randomHash 5
    st = new Date().getTime()
    console.log "data start #{ha}".red
    obj = @site.dataObject s,_path.relative "#{process.cwd()}/#{@site.path.states}/../",@path
    obj.$site   = @site
    obj.$req    = state.req
    obj.$res    = state.res
    obj.$user   = state.req.user
    obj.$session= state.req.session
    obj.$register= state.req.register
    obj.$cookie = state.req.cookie
    obj.$status = state.req.status
    console.log (""+((new Date().getTime())-st)).yellow
    if (obj.get?) && (typeof obj.get == 'function')
      console.log obj.get
      get_ = obj.get
      obj.get = (args...)=>
        get_.apply(obj,args).then (a)=>
          console.log "data stop #{ha}".red+(""+((new Date().getTime())-st)).yellow
          return a

    return obj
