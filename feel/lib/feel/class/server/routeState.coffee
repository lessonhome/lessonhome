


class RouteState
  constructor : (@statename,@req,@res,@site)->
    @o =
      res : @res
      req : @req
    @state = CLONE @site.state[@statename].state.struct
    @modules  = {}
    @css      = ""
  go : =>
    @parse @state
    @res.writeHead 200
    for modname of @modules
      if @site.modules[modname].allCss
        @css += "<style id=\"f-css-#{modname}\">\n#{@site.modules[modname].allCss}\n</style>\n"
    @res.end('<!DOCTYPE html><html><head><meta charset="utf-8"><title>'+
      @site.state[@statename].title+'</title>'+@css+'</head><body>'+@state._html+'</body></html>'
    )
  parse : (now)=>
    for key,val of now
      if typeof val == 'object'
        @parse val
    if now._isModule
      @modules[now._name] = true
      o = @getO now
      if !@site.modules[now._name]?
        throw new Error "can't find module '#{now._name}' in state '#{@statename}'"
      now._html = @site.modules[now._name].doJade o

  getO  : (obj)=>
    ret = {}
    for key,val of obj
      ret[key] = val
      if typeof val == 'object'
        ret[key] = @getO val
      if ret[key]?._isModule
        html = ""
        if ret[key]._html?
          ret[key] = ret[key]._html
    return ret
  

module.exports = RouteState


