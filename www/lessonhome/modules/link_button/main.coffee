
class @main extends EE
  show : =>
    @link = @dom.find "a"

    @link.on     'mousedown', => @link.addClass('press')
    $('body').on 'mouseup',    => @link.removeClass 'press'



