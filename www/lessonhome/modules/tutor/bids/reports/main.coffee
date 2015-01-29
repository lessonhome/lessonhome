class @main extends EE
  show : =>
    Feel.FirstBidBorderRadius(@dom)

    @hint = @dom.find(".hint")
    @button = @hint.find(".button")
    @button.on 'click', @hint_button_click

  hint_button_click: =>
    if @button.hasClass("closed")
      @hint.css("margin-bottom", "34px")
    else @hint.css("margin-bottom", "55px")