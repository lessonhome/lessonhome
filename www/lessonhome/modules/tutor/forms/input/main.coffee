class @main extends EE
  constructor : ->
  show : =>
    @box = @dom.find ".box"
    @box.on 'mouseover', => @box.addClass 'hover'
    @box.on 'mouseout', => @box.removeClass 'hover'
