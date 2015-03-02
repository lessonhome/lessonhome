class @main extends EE
  show : =>
    @sign = @dom.find ".sign"
    @field = @dom.find ".field"

    @sign.on 'click', => @change_visibility @field

    @show_hint_control @dom


  change_visibility: (element)=>
    if element.css("display") == "none"
      element.css("display", "block")
      @emit 'show'
    else
      element.css("display", "none")
      @emit 'hide'

  show_hint_control: (dom)=>
    hint = dom.find ".hint"
    button = hint.find ".button"
    bottom_block = hint.find ".bottom_block"
    button.on 'click', => @hint_button_click(bottom_block, button )

  hint_button_click: (hidden_block, button) ->
    @change_visibility hidden_block
    button_text = button.find(".text")
    if button.hasClass("open")
      button.removeClass("open")
      button.addClass("closed")
      button_text.html("раскрыть")
    else
      button.removeClass("closed")
      button.addClass("open")
      button_text.html("скрыть")

