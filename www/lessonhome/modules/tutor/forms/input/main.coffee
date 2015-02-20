class @main extends EE
  constructor : ->
  show : =>
    @input = @dom.find "input"
    @input.on 'mouseover', => @input.addClass 'hover'
    @input.on 'mouseout', => @input.removeClass 'hover'


  setValue: (value)=>
    @input.html(value)