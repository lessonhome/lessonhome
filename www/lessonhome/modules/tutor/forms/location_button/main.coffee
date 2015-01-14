
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
    @button.addClass 'inactive'
    @emit 'disable'
  click : =>
    return if @active
    @active = true
    @button.removeClass 'inactive'
    @button.addClass 'active'
    @emit 'active'




