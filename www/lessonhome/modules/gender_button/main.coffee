class @main extends EE
  Dom : =>
    @button = @dom.find ".button_box"
    @active = @button.hasClass 'active'
  show : =>
    @button.on 'click', @click
    @button.on 'mousedown', @buttonMouseDown
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
    @button.addClass 'inactive'
    @button.removeClass 'active'
  click : =>
    @active = !@active
    if @active
      @emit 'active'
      @button.addClass 'active'
      #@button.removeClass 'inactive'
    else
      @emit 'inactive'
      @button.addClass 'inactive'
      @button.removeClass 'active'
  setActive : =>
    @active = !@active
    @button.addClass 'active'
    @emit 'active'



# listen emit in parent module and do toggle


