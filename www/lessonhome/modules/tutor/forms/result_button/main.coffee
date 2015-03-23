

class @main extends EE
  show : =>
    @button = @dom.find ".button_box"
    @button.on 'click', @click

    @button.on    'mousedown', => @button.addClass('press')
    @button.on    'mouseup',   => @button.removeClass('press')
    $('body').on  'mouseup',   => @button.removeClass('press')

  disable : =>
    @button.removeClass 'active'
    @button.addClass 'inactive'

  click : =>
    @button.toggleClass 'active inactive'
    @emit 'active'


# listen emit in parent module and do toggle


###class @main extends EE
  constructor : ->
  show : =>
    @button = @dom.find ".button"
    @active = @button.hasClass 'active'
    @dom.on 'click', @click
  disable : =>
    if !@active then return
    @active = false
    @button.removeClass 'active'
    @emit 'disable'
  click : =>
    return if @active
    @active = true
    @button.addClass 'active'
    @emit 'active'



###
