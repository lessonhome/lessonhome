


class RouteState
  constructor : (@statename,@req,@res,@site)->
    @o =
      res : @res
      req : @req
    @state = CLONE @site.state[@statename].state.struct
    @modules  = {}
    @css      = ""
    @jsModules = ""
    @jsClient = Feel.clientJs
  go : =>
    @stack = []
    @parse @state
    @res.writeHead 200
      
    if @site.modules['default'].allCss
      @cssModule 'default'
    for modname of @modules
      if @site.modules[modname].allCss
        @cssModule modname
    for modname of @modules
      if @site.modules[modname].allCoffee
        @jsModules += "$Feel.modules['#{modname}'] = #{@site.modules[modname].allCoffee};"
    @res.end('<!DOCTYPE html><html><head><meta charset="utf-8">'+
        #      "<link href='http://fonts.googleapis.com/css?family=Open+Sans&subset=latin,cyrillic' rel='stylesheet' type='text/css'>"+
                '<title>'+
      @site.state[@statename].title+'</title>'+@css+'</head><body>'+@state._html+
      '<script id="feel-js-client">
          var $Feel = {
            modules : {}
          };(function(){'+@jsClient+'}).call($Feel);
      </script>'+
      '<script id="feed-js-modules">'+@jsModules+'</script>'+
      '<script id="feel-js-startFeel">Feel.init();</script>'+
      '</body></html>'
    )
  cssModule : (modname)=>
    @css += "<style id=\"f-css-#{modname}\">\n#{@site.modules[modname].allCss}\n</style>\n"
    
  parse : (now,uniq)=>
    if now._isModule
      uniq = Math.floor Math.random()*10000
      m = now._name.match /^\/\/(.*)$/
      if m
        unless @stack.length
          throw new Error "can't find parent module for // in modname '#{now._name}' 
                            in state '#{@statename}'"
        now._name = @stack[@stack.length-1]+"/#{m[1]}"
      @stack.push now._name
    for key,val of now
      if typeof val == 'object'
        @parse val,uniq
    if now._isModule
      @modules[now._name] = true
      o = @getO now,uniq
      if !@site.modules[now._name]?
        throw new Error "can't find module '#{now._name}' in state '#{@statename}'"
      now._html = @site.modules[now._name].doJade o
      @stack.pop()

  getO  : (obj,uniq)=>
    ret = {}
    for key,val of obj
      ret[key] = val
      if typeof val == 'object'
        ret[key] = @getO val,uniq
      if ret[key]?._isModule
        html = ""
        if ret[key]._html?
          console.log ret[key]._name
          idn = ret[key]._name.replace /\//g, '-'
          ret[key] = ret[key]._html.replace "m-#{idn}", "m-#{idn}\" class=\"m-#{uniq}-#{idn}"
          
    return ret
  

module.exports = RouteState


