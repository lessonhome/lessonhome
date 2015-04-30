class @main
  Dom   : =>
    @hint = @found.hint
    @close_block = @found.close_block
  show  : =>
    @callback_toggle = @tree.callback_toggle.class
    @callback_toggle.on 'sec_active', =>
      @hint.show()

    @close_block.on 'click', =>
      @hint.hide()
