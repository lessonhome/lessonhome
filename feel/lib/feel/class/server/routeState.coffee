


class RouteState
  constructor : (@statename,@req,@res,@site)->
    @o =
      res : @res
      req : @req
    @state = @site.state[@statename].make()
    @tags = {}
    @getTop()
    @walk_tree_down @top,(node)=>
      if node._isState
        for k of node.__state.tag
          @tags[k] = true
        node.__state.page_tags = @tags
    if @top._isState
      @top.__state.page_tags = @tags
    @modules  = {}
    @css      = ""
    @jsModules = ""
    @jsClient = Feel.clientJs

  getTop : (node)=>
    return @top if @top?
    node ?= @state
    if node.parent?
      return @getTop node.parent
    else
      return @top = node.tree
  getTree : (top)=>
    tree = {}
    for key,val of top
      if (typeof val == 'function' || typeof val == 'object') && !val._smart
        tree[key] = @getTree val
      else
        tree[key] = val
    return tree
  walk_tree_down : (node,foo)=>
    if (typeof node == 'object' || typeof node == 'function') && !node?._smart
      foo node
      for key,val of node
        @walk_tree_down node[key],foo
  go : =>
    @stack = []
    @parse @top,null,@top,@top
    @res.writeHead 200
    
    if @site.modules['default'].allCss && !@modules['default']?
      @cssModule 'default'
    for modname of @modules
      if @site.modules[modname].allCss
        @cssModule modname
    for modname of @modules
      if @site.modules[modname].allCoffee
        @jsModules += "$Feel.modules['#{modname}'] = #{@site.modules[modname].allCoffee};"
    title   = @state.title
    title  ?= @statename
    end  = ""
    end += '<!DOCTYPE html><html><head><meta charset="utf-8"><title>'
    end += title+'</title>'+@css+'</head><body>'+@top._html
    @removeHtml @top
    json_tree = JSON.stringify(@getTree(@top))
    end +=
      @site.moduleJsTag('lib/jquery')+
      @site.moduleJsTag('lib/q')+
      @site.moduleJsTag('lib/event_emitter')+
      '
      <script id="feel-js-client">
          window.EE = EventEmitter;
          var $Feel = {}; 
          $Feel.root = {
              "tree" : '+json_tree+'
          };
          $Feel.modules = {};
          (function(){
            '+@jsClient+'
            
            }).call($Feel);
      </script>'+
      '<script id="feed-js-modules">
          console.log("Feel",$Feel); 
      '+@jsModules+'</script>'+
      '<script id="feel-js-startFeel">Feel.init();</script>'+
      '</body></html>'
    @res.end end
    console.log "state #{@statename}"
  removeHtml : (node)=>
    for key,val of node
      if key == '_html'
        delete node[key]
      else if typeof val == 'object'
        @removeHtml val
  cssModule : (modname)=>
    @css += "<style id=\"f-css-#{modname}\">\n#{@site.modules[modname].allCss}\n</style>\n"
    
  parse : (now,uniq,module,state)=>
    new_module = module
    new_state  = state
    if now._isModule
      uniq = Math.floor Math.random()*10000
      now._uniq?= uniq
      uniq = now._uniq
      m = now._name.match /^\/\/(.*)$/
      if m
        unless @stack.length
          throw new Error "can't find parent module for // in modname '#{now._name}' 
                            in state '#{@statename}'"
        now._name = @stack[@stack.length-1]+"/#{m[1]}"
      @stack.push now._name
    for key,val of now
      if typeof val == 'object'
        if val.__state?
          new_state = val
        else
          new_state = state
        if val._isModule
          new_module = val
        else
          new_module = module
        @parse val,uniq,new_module,new_state
    if now._isModule
      @modules[now._name] = true
      o = @getO now,uniq
      if !@site.modules[now._name]?
        throw new Error "can't find module '#{now._name}' in state '#{@statename}'"
      now._html = @site.modules[now._name].doJade o,@,state.__state
      @stack.pop()

  getO  : (obj,uniq)=>
    ret = {}
    for key,val of obj
      ret[key] = val
      if typeof val == 'object'
        ret[key] = @getO val,uniq
      if ret[key]?._isModule
        ret[key]._uniq?= Math.floor Math.random()*10000
        html = ""
        if ret[key]._html?
          idn = ret[key]._name.replace /\//g, '-'
          ret[key] = ret[key]._html.replace "m-#{idn}", "m-#{idn}\" uniq=\"#{uniq}:#{ret[key]._uniq}\" class=\"m-#{uniq}-#{idn}"
          
    return ret
  

module.exports = RouteState


