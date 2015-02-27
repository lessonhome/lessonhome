
class @main extends EE
  show : =>
    @button = @dom.find ".button_box"
    @button.on    'mousedown', => @button.addClass('press')
    @button.on    'mouseup',   => @button.removeClass('press')
    $('body').on  'mouseup',   => @button.removeClass('press')



