


class RouteState
  constructor : (@statename,@req,@res,@site)->
    @o =
      res : @res
      req : @req
    console.log @statename
    @state = CLONE @site.state[@statename].state.struct
    console.log @state
  go : =>
    @parse @state
    console.log @state._html
    @res.writeHead 200
    @res.end @state._html
  parse : (now)=>
    for key,val of now
      if typeof val == 'object'
        @parse val
    console.log 'now',now
    if now._isModule
      o = @getO now
      console.log 'o:',o
      if !@site.modules[now._name]?
        throw new Error "can't find module '#{now._name}' in state '#{@statename}'"
      now._html = @site.modules[now._name].doJade o

  getO  : (obj)=>
    ret = {}
    for key,val of obj
      ret[key] = val
      if typeof val == 'object'
        ret[key] = @getO val
      if ret[key]._isModule
        html = ""
        if ret[key]._html?
          ret[key] = ret[key]._html
    return ret
  

module.exports = RouteState


