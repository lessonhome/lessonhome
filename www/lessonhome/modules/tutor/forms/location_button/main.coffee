class @main extends EE
  show : =>
    @button = @dom.find ".button_box"
    @active = @button.hasClass 'active'
    @button.on 'click', @click

    @button.on    'mousedown', => @button.addClass('press')
    @button.on    'mouseup',   => @button.removeClass('press')
    $('body').on  'mouseup',   => @button.removeClass('press')

  click : =>
    if @button.is '.active'
      @button.removeClass 'active'
      @button.addClass 'inactive'
    else
      @button.removeClass 'inactive'
      @button.addClass 'active'
