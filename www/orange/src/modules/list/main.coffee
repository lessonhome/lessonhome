

class @main
  constructor : ->
    @showed = false
  init : (cb)->
    
  dom : ->
    @button = @dom.find '.button'
    @list   = @dom.find '.list'
  show : ->
    @button.on 'click', @onClick
    
  hide : ->
    @button.off()
  
  onClick : =>
    if @showed
      @list.hide()
    else
      @list.show()
    @showed = !@showed

