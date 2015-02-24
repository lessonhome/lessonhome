class @main extends EE
  show : =>
    @click_box = @dom.find ".click_box"
    @popup_box = @click_box.next()
    @close_box = @popup_box.find ".close_box"
    @popupVisible = @popup_box.is ':visible'
    @click_box.on 'click', @togglePopup
    @close_box.on 'click', @hidePopup

  togglePopup : =>
    @popupVisible = !@popupVisible
    @popup_box.toggle @popupVisible
    if @popupVisible
      @emit 'showPopup'
    else
      @emit 'hidePopup'
  hidePopup : =>
    return unless @popupVisible
    @popupVisible = false
    @popup_box.hide()
    @emit 'hidePopup'