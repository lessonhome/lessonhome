
RouteState = require './routeState'
_cookies = require 'cookies'

class Router
  constructor : (@site)->
    @_redirects = require process.cwd()+"/www/#{@site.name}/router/redirects"
    @url =
      text  : {}
      reg   : []
  init : => do Q.async =>
    @redis_cache = _Helper('redis/cache')
    Q.spawn => @redis_cache.get()
    try @head = _fs.readFileSync(process.cwd()+"/www/#{@site.name}/config/head/head.html").toString()
    try @body = _fs.readFileSync(process.cwd()+"/www/#{@site.name}/config/body/body.html").toString()
    @head ?= ''
    @body ?= ''
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
  paymaster : (req,res)=> do Q.async =>
    req.body = yield req.body
    {status,body} = yield Feel.jobs.solve 'waitPay',{url:req.url,body:req.body}
    res.statusCode = status
    res.end body
  handler : (req,res)=> do Q.async =>
    req.site = @site
    req.status = (args...)=> @site.status req,res,args...
    if (redirect = @_redirects?.redirect?[req?.url])?
      return @redirect req,res,redirect
    if req.url == '/favicon.ico'
      req.url = '/file/666/favicon.ico'
    if req.url.match /\/paymaster\/payment/
      return @paymaster req,res
    if req.url.match /^\/(js|jsfile|jsfilet|urlform|jsclient)\/.*/
      return Q().then => @site.handler req,res,@site.name
    if req.url.match /^\/file\/.*/
      return Q().then => Feel.static.handler req,res,@site.name
    console.log req.originalUrl.yellow
    cookie = new _cookies req,res
    req.cookie = cookie
    ucook = cookie.get('urldata') ? '%257B%257D'
    ucook = decodeURIComponent(decodeURIComponent(ucook)) ? '{}'
    ucook = JSON.parse(ucook || "{}") ? {}
    #ucook = yield @site.urldata.d2u ucook
    ucookstr = ''
    for key,val of ucook
      continue unless key
      ucookstr += '&' if ucookstr
      ucookstr += key
      ucookstr += '='+val if val?
    if ucookstr
      req.udata ?= ''
      req.udata += "&" if req.udata
      req.udata += ucookstr
    _session = cookie.get 'session'
    req.udata = yield @site.urldata.u2d req.udata
    req.udata = yield req.udata
    req.udataString = yield @site.urldata.d2u req.udata
    req.uniqHash = "#{_session || ""}:#{req.url}?#{req.udataString}"
    req.udatadefault = @site.urldata.u2d ""
    try
      if _production && (cache = yield @redis_cache.get req.uniqHash)
        console.log "from redis cache".grey,req.uniqHash.grey
        res.setHeader 'Access-Control-Allow-Origin', '*'
        res.setHeader 'Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE'
        res.setHeader 'Access-Control-Allow-Headers', 'X-Requested-With,content-type'
        res.setHeader 'Access-Control-Allow-Credentials', true
        res.setHeader 'Vary','Accept-Encoding'
        res.setHeader 'Cache-Control', 'public, max-age='+cache.d
        res.setHeader 'content-encoding', cache.encoding
        d = new Date()
        d.setTime d.getTime()+30000
        res.setHeader 'Expires',d.toGMTString()
        if req.headers['if-none-match'] == cache.etag
          res.statusCode = 304
          res.end()
          return
        res.setHeader 'ETag',cache.etag
        res.statusCode = 200
        data = new Buffer(cache.data, 'hex')
        res.setHeader 'content-length',data.length
        res.end data
        return
    catch e
      console.error Exception e
    
    yield @setSession req,res,cookie,_session
    req.udatadefault = yield req.udatadefault
    req.udata ?= {}
    req.udatadefault ?= {}
    if req.url.match /^\/(upload)\/.*/
      return Q().then => @site.handler req,res,@site.name
    if req.url.match /^\/(uploaded)\/.*/
      return Q().then => @site.handler req,res,@site.name
    if req.url.match /^\/form\/tutor\/login$/
      uredirect = _setKey req.udata,'accessRedirect.redirect'
      if uredirect
        _setKey req.udata,'accessRedirect.redirect',''
      else
        uredirect = '/tutor/profile'
      return @redirect req,res,uredirect
    if req.url.match /^\/form\/tutor\/register$/
      return @redirect req,res,'/tutor/profile/first_step'
    if req.url.match /^\/form\/tutor\/logout$/
      yield @setSession req,res,cookie,""
      ahash = cookie.get 'adminHash'
      if ahash
        cookie.set 'adminHash'
        yield req.register.removeAdminHash ahash
      return @redirect req,res,'/'
    req.udata.abTest ?= {}
    try
      abcookie = JSON.parse((decodeURIComponent cookie.get 'abTest') || "{}")
    abcookie ?= {}
    abchanged = false
    for key,val of req.udata.abTest
      if val < 0
        abchanged = true
        delete abcookie[key]
      else if val > 0
        abchanged = true
        abcookie[key] = val
    if abchanged
      try
        cookie.set 'abTest', encodeURIComponent JSON.stringify abcookie
    if (abTest = abcookie[req.url.replace(/\//,'')])?
      if abTest>0
        nurl = req.url + '_abTest_'+abTest
        if @url.text[nurl]?
          req.url = nurl
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
      return yield Feel.static.handlerRoot req,res,@site.name
      return Feel.res404 req,res
    route = new RouteState statename,req,res,@site
    return route.go()
  setSession : (req,res,cookie,session)=> do Q.async =>
    req.register = @site.register
    unknown = cookie.get 'unknown'
    register = yield @site.register.register session,unknown,cookie.get('adminHash')
    req.session = register.session
    cookie.set 'session',null,{
      #maxAge : (60*60*24*365)
      expires: new Date("21 May 2020 10:12")
      overwrite : true
    }
    cookie.set 'session',register.session, {
      #maxAge : (60*60*24*365)
      expires: new Date("21 May 2020 10:12")
      overwrite : true
    }
    cookie.set 'unknown',register.account.unknown,{httpOnly:false} if register.account.unknown != unknown
    req.user = register.account
  redirect : (req,res,location='/')=> do Q.async =>
    yield console.log 'redirect',location
    res.statusCode = 302
    location = yield req.udataToUrl location
    res.setHeader 'location',location
    res.end()
    

module.exports = Router
