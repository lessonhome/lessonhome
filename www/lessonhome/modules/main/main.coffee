class @main extends EE
  show: =>

    @startSearch    = @dom.find(".start_search").find(".button")
    @listSubject    = @tree.filter_top.list_subject.class
    @inOut          = @tree.header.button_in_out.class
    @headerBackCall = @tree.header.back_call.class
    @footerBackCall = @tree.footer.back_call.class

    @footerBackCall.on  'showPopup', =>
      @inOut.hidePopup()
      @headerBackCall.hidePopup()

    @headerBackCall.on 'showPopup', @footerBackCall.hidePopup
    @inOut         .on 'showPopup', @footerBackCall.hidePopup

    @startSearch.on 'click', =>
      $('body').scrollTop(0)
      @listSubject.focusInput()





