class @main
  Dom : =>
    @trigger = @tree.trigger.class.dom
    @block = @found.block
    @btn_close = @block.find '.close_box:first'
  show : =>
    $(document).on 'click', => @hideBlock()
    @btn_close.on 'click', => @hideBlock()
    @block.on 'click', (e) => e.stopPropagation()
    @trigger.on 'click', (e) =>
      if @block.is ':visible'then @hideBlock()
      else @showBlock()
      e.stopPropagation()
      return false
  hideBlock : =>
    @block.hide()
  showBlock : =>
    @block.show()