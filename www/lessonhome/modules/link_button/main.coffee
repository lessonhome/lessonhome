
class @main extends EE
  show : =>
    @link = @dom.find "a"

    @link.on     'mousedown', => @link.addClass('press').removeClass 'hover'
    @link.on     'mouseover', => @link.addClass 'hover'
    @link.on     'mouseout',  => @link.removeClass 'hover'
    @link.on     'mouseup',   => @link.removeClass('press').addClass 'hover'
    $('body').on 'mouseup',    => @link.removeClass 'press'



