class @main extends EE
  show : =>
    Feel.FirstBidBorderRadius(@dom)
    @hint = @tree.hint.class
    @illustrations = @dom.find ".illustrations"
    @hint.on 'hide', => @illustrations.hide()
    @hint.on 'show', => @illustrations.show()