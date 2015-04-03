
class @main extends EE
  show : =>
    @button = @dom.find ".button_box"
    @button.on    'mousedown', @mdown
  mdown : =>
    @button.addClass 'press'
    $('body').on 'mouseup.button_add',@mup
    $('body').on 'mouseleave.button_add',@mup
  mup : =>
    $('body').off 'mouseup.button_add'
    $('body').off 'mouseleave.button_add'
    @button.removeClass 'press'
