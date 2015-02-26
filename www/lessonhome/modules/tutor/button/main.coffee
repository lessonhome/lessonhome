
class @main extends EE
  show : =>
    @button = @dom.find ".button_box"

    @button.on    'mousedown', => @button.addClass('press').removeClass 'hover'
    @button.on    'mouseover', => @button.addClass 'hover'
    @button.on    'mouseout',  => @button.removeClass 'hover'
    @button.on    'mouseup',   => @button.removeClass('press').addClass 'hover'
    $('body').on  'mouseup',   => @button.removeClass('press')



