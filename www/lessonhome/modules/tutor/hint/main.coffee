class @main extends EE
  show : =>
    @sign = @dom.find ".sign"
    @field = @dom.find ".field"

    @sign.on 'click', @change_visibility

  change_visibility : =>
    if @field.hasClass 'hidden'
      @field.removeClass 'hidden'
    else
      @field.addClass 'hidden'



