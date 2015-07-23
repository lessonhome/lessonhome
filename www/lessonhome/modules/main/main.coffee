class @main extends EE
  Dom : =>
    @popup_wrap = $ @found.popup_wrap
    @content    = @found.content

  show: =>

    @startSearch    = @dom.find(".start_search").find(".button")
    @inOut          = @tree.header.button_in_out.class
    @headerBackCall = @tree.header.back_call.class
    @footerBackCall = @tree.footer.back_call.class

    @footerBackCall.on  'showPopup', =>
      @inOut.hidePopup()
      @headerBackCall.hidePopup()

    @headerBackCall.on 'showPopup', @footerBackCall.hidePopup
    @inOut         .on 'showPopup', @footerBackCall.hidePopup

    @startSearch.on 'click', =>
      if @tree.filter_top.list_subject
        $('body').scrollTop(0)
        @listSubject = @tree.filter_top.list_subject.class
        @listSubject.focusInput()

    @popup_wrap.on 'click',  @check_place_click

  check_place_click :(e) =>
    if (!@content.is(e.target) && @content.has(e.target).length == 0)
      Feel.go '/'

