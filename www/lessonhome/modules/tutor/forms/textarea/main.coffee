class @main extends EE
  constructor : ->
  show : =>
    @textarea = @dom.find "textarea"
    @textarea.on 'mouseover', => @textarea.addClass 'hover'
    @textarea.on 'mouseout', => @textarea.removeClass 'hover'
