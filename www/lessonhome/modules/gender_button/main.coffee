
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


