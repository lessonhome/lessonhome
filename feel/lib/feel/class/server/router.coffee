
RouteState = require './routeState'


class Router
  constructor : (@site)->
    @url =
      text  : {}
      reg   : []
  init : =>
    for statename,state of @site.state
      route = state.class::route
      if route
        if typeof route == 'string'
          @url.text[route] = statename
        else if route instanceof RegExp
          @url.reg.push [route,statename]
        else if route.length
          for r in route
            if typeof r == 'string'
              @url.text[r] = statename
            else if r instanceof RegExp
              @url.reg.push [r,statename]
            
  handler : (req,res)=>
    if req.url.match /^\/file\/.*/
      return Q().then => Feel.static.handler req,res,@site.name
    statename = ""
    if @url.text[req.url]?
      statename = @url.text[req.url]
    else
      for reg in @url.reg
        if req.url.match reg[0]
          statename = reg[1]
          @url.text[req.url] = statename
    if !statename
      res.writeHead 404
      res.end 'Error 404'
      return
    route = new RouteState statename,req,res,@site
    return Q().then route.go


module.exports = Router
