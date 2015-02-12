
class @main extends EE
  show : =>
    @button = @dom.find ".button"
    @button.on 'click', @click

  disable : =>
    @button.removeClass 'active'
    @button.addClass 'inactive'

  click : =>
    @button.toggleClass 'active inactive'
    @emit 'active'


