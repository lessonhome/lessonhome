class @main extends EE
  Dom   : =>
    @popup_wrap = $ @found.popup_wrap
    @content    = @found.content
  show  : =>
    Feel.FirstBidBorderRadius(@dom)
    #@hint = @tree.hint.class
    #@illustrations = @dom.find ".illustrations"
    #@hint.on 'hide', => @illustrations.hide()
    #@hint.on 'show', => @illustrations.show()


    @popup_wrap.on 'click',  @check_place_click


  check_place_click :(e) =>
    if (!@content.is(e.target) && @content.has(e.target).length == 0)
      Feel.go '/tutor/reports'
