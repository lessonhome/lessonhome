

$.cookie.defaults.path = '/'
$.cookie.defaults.expires = 365*2

Feel = undefined

class @Feel
  constructor : ->
    @_popupAdd = {}
    Feel = @
    window.Feel  = @
    @production = true if (window.location.hostname ? '').match /lessonhome\.ru/

  init : => do Q.async =>
    for key,val of $Feel.user?.type
      #if $Feel.user?.type?.admin
      if val
        $.cookie key,true
    yield Q.delay 1
    for key,val of $Feel
      @[key] = val
    for key,mod of $Feel.modules
      if mod.main?.prototype?
        mod.main::class = {}
        for name,obj of mod
          mod.main::class[name] = obj
      else if !mod._not_global
        for name,obj of mod
          window[name] = obj
          console.log "global class window['#{name}'];"


    try
      errorfunc = console.error
      myerrorfunc = =>
        Q.spawn =>
          try
            yield @sendActionOnce 'error_on_page'
          catch e
            console.error Exception e
        try
          errorfunc.apply console,arguments
        catch e
          console.error Exception e
          try
            errorfunc arguments...
          catch e
            console.error Exception e
        return
      console.error = myerrorfunc
    catch e
      console.error Exception e

    window.onerror = (e)=> @error e
    
    yield Q.delay 1
    @jobs = new @Jobs()
    yield @jobs.init()
    
    yield Q.delay 1
    urlData = new @urlData()
    @urlData = urlData
    yield urlData.init()
    yield Q.delay 1
    
    @dataM = new @DataM()
    yield @dataM.init()
    yield Q.delay 1
    
    @pbar = new @PBar()
    yield @pbar.init()
    yield Q.delay 1
    
    
    @active = new @activeState @root.tree
    yield @active.init()
    yield Q.delay 1
    
    setTimeout @checkUnknown,200

    $(document).on 'mousedown.popupAdd', @popupAddDown
    #$(document).on 'mouseleave.popupAdd', @popupAddLeave
    if $.cookie()?.tutor
      @sendActionOnceIf 'reaccess',1000*60*30

  const : (name)=> $Feel.constJson[name]

  error : (e,args...)=>
    Q.spawn => @sendActionOnce 'error_on_page'
    return unless e?
    e = new Error e unless e?.stack? || e?.name?
    e.message ?= ""
    for a in args
      e.message += a+"\n" if typeof a == 'string'
      e.message += JSON.stringify(a)+"\n" if a && typeof a == 'object'
    console.error e.name,e.message,e.stack
    @activeError()
    #console.error e.message
    #console.error e.stack
  activeError : ->
    return if @activated
    @activated = true
    return if location.hostname.match /lessonhome/
    div = $('<div id="g-global_error"></div>').appendTo('body')
    setInterval ->
      a = 0.5*(Math.sin((new Date().getTime())/300)+1)
      div.css 'box-shadow', "inset 0 10px 20px -10px rgba(255,0,0,#{a})"
    ,30
  autocomplete : (options,cb)=>
    o = ""
    for key,val of options
      o+= "&" if o.length
      o += "#{key}=#{val}"
    $.getJSON("/google?#{o}")
    .success (data)->
      cb? data
  autocompleteCity : (input,cb)=>
    @autocomplete {
      input : input
      #language : "ru"
      #components : "ru"
      types : "(cities)"
    },cb
  send : (context,name,args...)=> do Q.async =>
    quiet = false
    if args[args.length-1] == 'quiet'
      quiet = true
      args.pop()
    @pbar.start() unless quiet
    m = name.match /^([^\w]*)/
    pref = ""
    if m
      pref=m[1]
      name = name.substr pref.length
    @index ?= 0
    index = @index++
    d = Q.defer()
    serviceName = @resolve context,'/'+name,pref
    console.log serviceName
    return console.error 'bad service name: '+serviceName unless @servicesIp?[serviceName]?
    data = encodeURIComponent JSON.stringify args
    context = encodeURIComponent JSON.stringify context
    pref = encodeURIComponent JSON.stringify pref

    pport = 8082
    pport = 8084 if location.protocol == 'https:'
    udata = (yield @urlData.getU()) ? ""
    if udata
      udata += "&"
    _url= "//#{location.hostname}:#{@servicesIp[serviceName].port}/#{name}?data=#{data}&context=#{context}&#{udata}pref=#{pref}&callback=?"
    _cb = _hash(_url)
    window["jsonCallback#{_cb}"] = ->
    $.ajax({
      dataType : 'jsonp'
      jsonpCallback : "jsonCallback#{_cb}"
      contentType : 'application/json'
      method : 'GET'
      url:_url
      crossDomain : true
      cache : true
    })
    .success (data)=>
      @pbar.stop() unless quiet
      #d.resolve JSON.parse decodeURIComponent data.data
      if data?.status == 'failed'
        return d.reject data
      d.resolve data.data
    .error   (e)->
      d.reject e
    return d.promise
  json : (url,data)=> Q().then =>
    d = Q.defer()
    #data = encodeURIComponent JSON.stringify data
    $.ajax({
      data        : data
      dataType    : 'json'
      contentType : "application/json"
      method      : "POST"
      url         : url
    })
    .success (data)=>
      d.resolve data
    .error (e)=>
      d.reject e
    return d.promise
  unselect : (state)=>
    if state
      $('body').addClass 'unselect_all'
    else
      $('body').removeClass 'unselect_all'
  checkUnknown : =>
    unknown = $.cookie()?.unknown
    $.cookie('unknown', 'set'+@user.sessionpart) if unknown == 'need'
    
  go : (href,newwindow=false)=>
    q = do Q.async =>
      href = (yield @urlData.udataToUrl href)
      if href && (typeof href == 'string')
        unless newwindow
          window.location.href = href
        else
          window.open href,'_newtab'#, '_blank'
    q.done()
  gor : (href,newwindow=false)=> do Q.async =>
    href = (yield @urlData.udataToUrl href)
    return unless href && (typeof href == 'string')
    state = History.getState()
    History.pushState {},(state.title || $('head>title').text()),href
    yield Feel.urlData.initFromUrl()
  goBack : (def_url)=> Feel.go @getBack def_url
  getBack : (def_url)=>
    state = History.getState()
    if ((typeof document.referrer == 'string') || (!((""+document.referrer).match(/undefined/)))) &&
        (((""+document.referrer).indexOf document.location.href.substr(0,15))== 0)
      return document.referrer
    else if def_url && (typeof def_url == 'string') && (!def_url.match /undefined/)
      return def_url
    else return '#'

  formSubmit : (form)=> Q.spawn =>
    form = $(form)
    url = form.attr 'action'
    url = (yield @urlData.udataToUrl url)
    form.attr 'action',url
    form.submit()
    
  popupAdd : (main,foo,...,toggle=false)=>
    foo ?= main
    unless typeof foo == 'function'
      _foo = -> foo?.hide?()
    else
      _foo = foo
    @_popupAdd[_.random(true)] = {main,foo:_foo,toggle}
  popupAddLeave : =>
    for key,v of  @_popupAdd
      v?.foo?()
      delete @_popupAdd[key]
  popupAddDown  : (t)=>
    for key,v of  @_popupAdd
      continue if $.contains (v.main?[0] ? v.main),t.target
      v?.foo?()
      delete @_popupAdd[key]
  sendAction : (action,params)=>

    switch action
      when 'direct_bid', 'bid_popup'
        return null
      when 'bid_action'
        params?={}
        params['order_price'] = 1500

    @yaC ?= yaCounter30199739 ? undefined
    #return if Feel.user?.type?.admin || $.cookie.admin || (!@production)
    console.log action, params
    unless params?
      @yaC?.reachGoal? action
    else
      @yaC?.reachGoal? action,params
  sendActionOnce : (action,time, params)=>
    cook = $.cookie()?['sendAction__'+action]
      
    t = new Date().getTime()
    if time?
      $.cookie('sendAction__'+action,t)
      return if cook? && ((t-cook)<time)
    return if cook? && (!time?)
    $.cookie('sendAction__'+action,t)
    @sendAction action, params
  sendActionOnceIf : (action,time, params)=>
    t = new Date().getTime()
    cook = $.cookie()?['sendAction__'+action]
    return $.cookie('sendAction__'+action,t) unless cook?
    @sendActionOnce action,time, params
    
  ## args... :: data object
  sendGAction : (category,action,label,args...)=>
    @ga ?= ga ? undefined
    return if Feel.user?.type?.admin || $.cookie.admin || (!@production)
    @ga 'send','event',category,action,label,args...

  sendGActionOnce : (time,category,action,label,args...)=>
    key = "sendGAction__#{category}_#{action}_#{label}"
    cook = $.cookie()?[key]
    t = new Date().getTime()
    if time?
      $.cookie(key,t)
      return if cook? && ((t-cook)<time)
    return if cook? && (!time?)
    $.cookie(key,t)
    @sendGAction category,action,label,args...
  sendGActionOnceIf : (time,category,action,label,args...)=>
    key = "sendGAction__#{category}_#{action}_#{label}"
    t = new Date().getTime()
    cook = $.cookie()?[key]
    return $.cookie(key,t) unless cook?
    @sendGActionOnce arguments...

  login : (id)=> do Q.async =>
    yield @root.tree.class.$send('/relogin',id)
    yield @go '/form/tutor/login'
  sms : (args...)=> @root.tree.class.$send '/sms', args...
  resolve : (context,path,pref)=>
    name = pref+path.substr 1
    #"runtime#{path}.c.coffee"
    suffix  = ""
    postfix = name
    file = ""
    m = name.match /^(\w)\:(.*)$/
    if m
      suffix  = m[1]
      postfix = m[2]
    suffix = switch suffix
      when 's' then 'states'
      when 'm' then 'modules'
      when 'r' then 'runtime'
      when 'w' then 'workers'
      else ''
    m = context.match /^(\w+)\/(.*)$/
    s = m[1]
    p = m[2]
    if postfix.match /^\./
      suffix = s if !suffix
      file = _normalizePath suffix+"/"+p+"/"+postfix
    else if postfix.match /^\//
      suffix = "runtime" if !suffix
      file = _normalizePath suffix+postfix
    else
      suffix = "runtime" if !suffix
      file = _normalizePath suffix+"/"+postfix
    return file

Feel = new @Feel()
window.Feel = Feel

