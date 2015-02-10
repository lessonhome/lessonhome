
class @main extends EE
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
    @active = !@active
    if @button.hasClass 'active'
      @button.removeClass 'active'
      @button.addClass 'inactive'
    else
      @button.removeClass 'inactive'
      @button.addClass 'active'
    @emit 'active'


