

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

window.Feel = new @Feel()


