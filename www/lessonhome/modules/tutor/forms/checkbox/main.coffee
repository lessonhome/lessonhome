class @main extends EE
  show : =>
    @check = @dom.find(".check")
    @active = @check.hasClass 'active'
    @dom.on 'click',  @checkbox_click

  checkbox_click: =>
    @active = !@active
    if @active
      @check.addClass('active')
    else
      @check.removeClass('active')
    @emit 'active'    if      @active
    @emit 'inactive'  unless  @active


