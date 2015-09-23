class @main extends EE
  Dom: =>
    @telephone = @found.telephone
    @call_back_popup = @tree.call_back_popup.class
  show : =>
    @click_box = @dom.find ".click_box"
    @popup_box = @click_box.next()
    @close_box = @popup_box.find ".close_box"
    @popupVisible = @popup_box.is ':visible'
    #@dom.click @togglePopup

    ###
      $(@telephone).on 'click', @goCallbackPage()
      @click_box   .on 'click', @goCallbackPage()
      @close_box   .on 'click', @goCallbackPage()
    ###
    $(@telephone).on 'click', @togglePopup
    @click_box   .on 'click', @togglePopup
    @close_box   .on 'click', @hidePopup

    $(@call_back_popup).on 'sent', => @togglePopup
  togglePopup : =>
    unless @popup_box.is ':visible'
      @popup_box.show()
      Feel.popupAdd @dom,@popup_box
    else
      @popup_box.hide()
  hidePopup : =>
    @popup_box.hide()

  #goCallbackPage: => Q().then =>
    #yield Feel.go '/main_tutor_callback'
