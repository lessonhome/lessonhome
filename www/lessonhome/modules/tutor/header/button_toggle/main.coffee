class @main extends EE
  show : =>
    @button = @dom.find ".button_box"
    @active = @button.hasClass 'active'
    @dom.on 'click', @click

    @button.on    'mousedown', => @button.addClass('press')
    @button.on    'mouseup',   => @button.removeClass('press')
    $('body').on  'mouseup',   => @button.removeClass('press')


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




