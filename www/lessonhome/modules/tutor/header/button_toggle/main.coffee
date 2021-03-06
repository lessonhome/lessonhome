class @main extends EE
  Dom : =>
    @button_box   = @dom.find ".button_box"
  show : =>
    @dom.on 'click', @click
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


