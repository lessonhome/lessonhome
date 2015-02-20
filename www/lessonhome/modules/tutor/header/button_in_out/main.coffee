
###
  actions:
    show : ->
###

class @main extends EE
  show : =>
    @button = @dom.find ".button"
    @popup_box = @button.find ".popup_box"
    @close_box = @popup_box.filter ".close_box"
    @popupVisible = @popup_box.is ':visible'
    @button.on 'click', @togglePopup
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