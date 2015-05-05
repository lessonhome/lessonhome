
class @main extends EE
  show : =>
    @button = @dom.find ".button_box"
    @button.on    'mousedown', @mdown
  mdown : =>
    $('body').on 'mouseup.invite_button',@mup
    $('body').on 'mouseleave.invite_button',@mup
    @button.addClsas 'press'
  mup : =>
    $('body').off 'mouseup.invite_button'
    $('body').off 'mouseleave.invite_button'
    @button.removeClass 'press'


