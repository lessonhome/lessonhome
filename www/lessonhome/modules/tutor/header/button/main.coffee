

class @main extends EE
  Dom : =>
    #@a = @found.a
  show : =>
    #@a.on 'click', (e)=>
    #  e.preventDefault()
    
