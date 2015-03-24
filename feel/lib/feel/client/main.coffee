

class @Feel
  init : ->
    for key,val of $Feel
      @[key] = val
    for key,mod of $Feel.modules
      if mod.main?.prototype?
        mod.main::class = {}
        for name,obj of mod
          mod.main::class[name] = obj
      else for name,obj of mod
        window[name] = obj
        console.log "global class window['#{name}'];"
    @active = new @activeState @root.tree
    window.onerror = (e)=> @error e
  error : (e,args...)=>
    return unless e?
    e = new Error e unless e?.stack? || e?.name?
    e.message ?= ""
    for a in args
      e.message += a+"\n" if typeof a == 'string'
      e.message += JSON.stringify(a)+"\n" if typeof a == 'object'
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
      console.log data
      cb? data
  autocompleteCity : (input,cb)=>
    @autocomplete {
      input : input
      #language : "ru"
      #components : "ru"
      types : "(cities)"
    },cb
  send : (name,args...)=> Q().then =>
    @index ?= 0
    index = @index++
    window["jsonCallback#{index}"] = ->
    d = Q.defer()
    data = encodeURIComponent JSON.stringify args
    $.ajax({
      dataType : 'jsonp'
      jsonpCallback : "jsonCallback#{index}"
      contentType : 'application/json'
      method : 'GET'
      url:"//#{location.hostname}:8082/#{name}?data=#{data}&callback=?"
      crossDomain : true
    })
    .success (data)=>
      d.resolve JSON.parse decodeURIComponent data.data
    .error   (e)->
      d.reject e
    return d.promise




window.Feel = new @Feel()


