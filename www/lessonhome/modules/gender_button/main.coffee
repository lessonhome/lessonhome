class @main extends EE
  Dom : =>
    @button = @dom.find ".button_box"
    @active = @button.hasClass 'active'
  show : =>
    @button.on 'click', @click
    @button.on 'mousedown', @buttonMouseDown
  buttonMouseDown : =>
    @button.addClass('press')
    @button.on    'mouseup.gender_button',   @buttonMouseUp
    $('body').on  'mouseup.gender_button',   @buttonMouseUp
    $('body').on  'mouseleave.gender_button',   @buttonMouseUp

  buttonMouseUp : =>
    @button.removeClass('press')
    @button.off   'mouseup.gender_button'
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


