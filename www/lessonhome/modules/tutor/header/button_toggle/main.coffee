class @main extends EE
  Dom : =>
    @button_box   = @dom.find ".button_box"
    @active = @round_button.hasClass 'active'
  show : =>
    @dom.on 'click', @click
    console.log @tree.value
    if @tree.value? && @tree.value == 'active'
      @active = true
      @button_box.addClass 'active'
      @emit 'active'



  disable : =>
    if !@active then return
    @active = false
    @button_box.removeClass 'active'
    @emit 'disable'
  click : =>
    return if @active
    @active = true
    @button_box.addClass 'active'
    @emit 'active'


