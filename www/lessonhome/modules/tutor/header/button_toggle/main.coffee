class @main extends EE
  show : =>
    @button = @dom.find ".button_box"
    @active = @button.hasClass 'active'
    @dom.on 'click', @click

    @button.on    'mousedown', @mdown

  mdown : =>
    @button.addClass 'press'
    $('body').on 'mouseup.button_toggle', @mup
    $('body').on 'mouseleave.button_toggle', @mup
  mup   : =>
    @button.removeClass 'press'
    $('body').off 'mouseup.button_toggle'
    $('body').off 'mouseleave.button_toggle'

  disable : =>
    if !@active then return
    @active = false
    @button.removeClass 'active'
    @button.addClass 'inactive'
    @emit 'disable'
  click : =>
    return if @active
    @active = true
    @button.removeClass 'inactive'
    @button.addClass 'active'
    @emit 'active'




