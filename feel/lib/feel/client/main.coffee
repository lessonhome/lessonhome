

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
  error : =>
    msg = ""
    for a,i in arguments
      continue unless i
      msg += JSON.stringify(a)+"\n"
    console.error arguments[0]
    console.error msg

window.Feel = new @Feel()


