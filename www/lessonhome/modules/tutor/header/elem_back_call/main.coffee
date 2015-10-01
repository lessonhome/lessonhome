class @main
  Dom : =>
    @trigger = @tree.trigger.class.dom
    @block = @found.block
    @btn_close = @block.find '.close_box:first'
  show : =>
    @btn_close.on 'click', => @block.hide()
    @trigger.on 'click', (e) =>
      @toggle()
      return false

  toggle : =>
    if @block.is ':visible'
      @block.hide()
    else
      @block.show()
      Feel.popupAdd @dom, @block
