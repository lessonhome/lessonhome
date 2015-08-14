

class @Feel
  constructor : ->
    window.Feel  = @
    @production = true if (window.location.hostname ? '').match /lessonhome\.ru/

  init : => do Q.async =>
    for key,val of $Feel.user?.type
      #if $Feel.user?.type?.admin
      if val
        $.cookie key,true,{path:'/'}
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
    window.onerror = (e)=> @error e
    urlData = new @urlData()
    @urlData = urlData
    yield urlData.init()
    
    @pbar = new @PBar()
    yield @pbar.init()
    
    @active = new @activeState @root.tree
    yield @active.init()
    
    setTimeout @checkUnknown,200

    @_popupAdd = {}
    $(document).on 'mousedown.popupAdd', @popupAddDown
    #$(document).on 'mouseleave.popupAdd', @popupAddLeave
    if $.cookie 'tutor'
      @sendActionOnceIf 'reaccess',1000*60*30

  error : (e,args...)=>
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
    window["jsonCallback#{index}"] = ->
    d = Q.defer()
    data = encodeURIComponent JSON.stringify args
    context = encodeURIComponent JSON.stringify context
    pref = encodeURIComponent JSON.stringify pref

    pport = 8082
    pport = 8084 if location.protocol == 'https:'
    udata = (yield @urlData.getU()) ? ""
    if udata
      udata += "&"
    $.ajax({
      dataType : 'jsonp'
      jsonpCallback : "jsonCallback#{index}"
      contentType : 'application/json'
      method : 'GET'
      url:"//#{location.hostname}:#{pport}/#{name}?data=#{data}&context=#{context}&#{udata}pref=#{pref}&callback=?"
      crossDomain : true
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
    unknown = $.cookie('unknown')
    $.cookie 'unknown', 'set'+@user.sessionpart if unknown == 'need'
    
  go : (href)=>
    q = do Q.async =>
      href = (yield @urlData.udataToUrl href)
      window.location.href = href if href && (typeof href == 'string')
    q.done()
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
    @yaC ?= yaCounter30199739
    return if Feel.user?.type?.admin || $.cookie.admin || (!@production)
    unless params?
      @yaC?.reachGoal? action
    else
      @yaC?.reachGoal? action,params
  sendActionOnce : (action,time)=>
    cook = $.cookie('sendAction__'+action)
      
    t = new Date().getTime()
    if time?
      $.cookie('sendAction__'+action,t,{path:'/'})
      return if cook? && ((t-cook)<time)
    return if cook? && (!time?)
    $.cookie('sendAction__'+action,t,{path:'/'})
    @sendAction action
  sendActionOnceIf : (action,time)=>
    t = new Date().getTime()
    cook = $.cookie('sendAction__'+action)
    return $.cookie('sendAction__'+action,t,{path:'/'}) unless cook?
    @sendActionOnce action,time

  login : (id)=> do Q.async =>
    yield @root.tree.class.$send('/relogin',id)
    yield @go '/form/tutor/login'


window.Feel = new @Feel()

