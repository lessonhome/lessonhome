

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
    #console.error e.message
    #console.error e.stack
  

window.Feel = new @Feel()


