class @main extends EE
  constructor : ->
  show : =>
    @list = @dom.find ".drop_down_list"

    @list.on 'mouseover', => @list.addClass 'hover'
    @list.on 'mouseout', => @list.removeClass 'hover'



