

class @Feel
  init : ->
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
    @active = new @activeState @root.tree
    @pbar = new @PBar()
    @pbar.init()
    window.onerror = (e)=> @error e

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
  send : (context,name,args...)=> Q().then =>
    @pbar.start()
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
    $.ajax({
      dataType : 'jsonp'
      jsonpCallback : "jsonCallback#{index}"
      contentType : 'application/json'
      method : 'GET'
      url:"//#{location.hostname}:#{pport}/#{name}?data=#{data}&context=#{context}&pref=#{pref}&callback=?"
      crossDomain : true
    })
    .success (data)=>
      @pbar.stop()
      d.resolve JSON.parse decodeURIComponent data.data
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




window.Feel = new @Feel()

