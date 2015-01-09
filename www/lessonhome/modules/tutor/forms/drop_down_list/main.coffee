class @main extends EE
  constructor : ->
  show : =>
    @list = @dom.find ".drop_down_list"
    @input = @list.find "input"

    @list.on 'mouseover', => @input.addClass 'hover'
    @list.on 'mouseout', => @input.removeClass 'hover'
