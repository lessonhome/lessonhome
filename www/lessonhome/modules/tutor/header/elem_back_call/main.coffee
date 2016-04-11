class @main
  Dom : =>
    @block = @found.block
  show : =>
    @block.find '.close_box:first'
    .on 'click', => @block.hide()
    @tree.trigger.class.dom.on 'click', (e) =>
      @toggle()
      return false

  toggle : =>
    if @block.is ':visible'
      @block.hide()
    else
      @block.show()
      Feel.popupAdd @dom, @block
