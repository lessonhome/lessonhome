class @main extends EE
  show : =>
    @button = @dom.find ".button_box"
    @button.on 'click', @click
    @active = @button.hasClass 'active'
    @button.on    'mousedown', @buttonMouseDown
  buttonMouseDown : =>
    @button.addClass('press')
    $('body').on  'mouseup.gender_button',   @buttonMouseUp
    $('body').on  'mouseleave.gender_button',   @buttonMouseUp

  buttonMouseUp : =>
    @button.removeClass('press')
    $('body').off 'mouseup.gender_button'
    $('body').off 'mouseleave.gender_button'
  disable : =>
    return unless @active
    @active = false
    @button.toggleClass 'active inactive'
  click : =>
    @active = !@active
    @button.toggleClass 'active inactive'
    @emit 'active' if @active


# listen emit in parent module and do toggle


