


class @main extends EE
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


