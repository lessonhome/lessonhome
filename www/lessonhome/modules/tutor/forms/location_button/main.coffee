class @main extends EE
  show : =>
    @button = @dom.find ".button_box"
    @active = @button.hasClass 'active'
    @button.on 'click', @click

    @button.on    'mousedown', @mdown
  mdown : =>
    @button.addClass('press')
    $('body').on  'mouseup.location_button', @mup
    $('body').on  'mouseleave.location_button', @mup
  mup : =>
    $('body').off  'mouseup.location_button'
    $('body').off  'mouseleave.location_button'
  mup : =>
    @button.removeClass('press')
  click : =>
    if @button.is '.active'
      @button.removeClass 'active'
      @button.addClass 'inactive'
    else
      @button.removeClass 'inactive'
      @button.addClass 'active'

  getValue : => @button.hasClass 'active'
