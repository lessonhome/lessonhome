class @main extends EE
  constructor : ->
  show : =>
    @box = @dom.find ".box"
    @input = @box.children "input"

    @input.on 'focus', => @box.addClass 'focus'
    @input.on 'focusout', => @box.removeClass 'focus'

  setValue: (value)=>
    @input.html(value)
