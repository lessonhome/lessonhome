

class @Feel
  init : ->
    for key,val of $Feel
      @[key] = val
    for key,mod of $Feel.modules
      if mod.main?.prototype?
        mod.main::class = {}
        for name,obj of mod
          mod.main::class[name] = obj

    @active = new @activeState @root.tree

window.Feel = new @Feel()


