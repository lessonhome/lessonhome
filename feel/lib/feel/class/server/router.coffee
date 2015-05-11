
RouteState = require './routeState'
_cookies = require 'cookies'

class Router
  constructor : (@site)->
    @_redirects = require process.cwd()+"/www/#{@site.name}/router/redirects"
    @url =
      text  : {}
      reg   : []
  init : =>
    for statename,state of @site.state
      route = state.class::route
      if route
        if typeof route == 'string'
          if @url.text[route]?
            throw new Error "same route('#{route}') in states '#{@url.text[route]}'
                                                          and '#{statename}'!"
          @url.text[route] = statename
        else if route instanceof RegExp
          @url.reg.push [route,statename]
        else if route.length
          for r in route
            if typeof r == 'string'
              if @url.text[r]?
                throw new Error "same route('#{r}') in states '#{@url.text[r]}'
                                                          and '#{statename}'!"
              @url.text[r] = statename
            else if r instanceof RegExp
              @url.reg.push [r,statename]
            
  handler : (req,res)=> do Q.async =>
    req.status = (args...)=> @site.status req,res,args...
    if (redirect = @_redirects?.redirect?[req?.url])?
      return @redirect req,res,redirect
    if req.url == '/favicon.ico'
      req.url = '/file/666/favicon.ico'

    if req.url.match /^\/(js|jsfile|jsfilet)\/.*/
      return Q().then => @site.handler req,res,@site.name
    if req.url.match /^\/file\/.*/
      return Q().then => Feel.static.handler req,res,@site.name
    cookie = new _cookies req,res
    req.cookie = cookie
    _session = cookie.get 'session'
    console.log  req.url,_session
    yield @setSession req,res,cookie,_session
    if req.url.match /^\/(upload)\/.*/
      return Q().then => @site.handler req,res,@site.name
    if req.url.match /^\/(uploaded)\/.*/
      return Q().then => @site.handler req,res,@site.name
    if req.url.match /^\/form\/tutor\/login$/
      return @redirect req,res,'/tutor/search_bids'
    if req.url.match /^\/form\/tutor\/register$/
      return @redirect req,res,'/tutor/profile/first_step'
    if req.url.match /^\/form\/tutor\/logout$/
      yield @setSession req,res,cookie,""
      return @redirect req,res,'/'
    statename = ""
    if @url.text[req.url]?
      statename = @url.text[req.url]
    else
      for reg in @url.reg
        if req.url.match reg[0]
          statename = reg[1]
          @url.text[req.url] = statename
    if !statename
      #unless req.url == '/urls'
      #  req.url = '/urls'
      #  return @handler req,res
      return Feel.res404 req,res
    route = new RouteState statename,req,res,@site
    return route.go()
  setSession : (req,res,cookie,session)=> do Q.async =>
    req.register = @site.register
    register = yield @site.register.register session
    req.session = register.session
    cookie.set 'session'
    cookie.set 'session',register.session
    req.user = register.account
  redirect : (req,res,location='/')=> do Q.async =>
    yield console.log 'redirect',location
    res.statusCode = 302
    res.setHeader 'location',location
    res.end()
    

module.exports = Router
