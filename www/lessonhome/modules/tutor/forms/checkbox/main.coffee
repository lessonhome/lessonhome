class @main extends EE
  show : =>
    @check = @dom.find(".check")
    @active = @check.hasClass 'active'
    @on 'click',  @checkbox_click
    @on 'hover', @hover






  checkbox_click: =>
    @active = !@active
    if @active
      @check.addClass('active')
    else
      @check.removeClass('active')
    @emit 'active'    if      @active
    @emit 'inactive'  unless  @active

  hover : (hover)=>
    if hover
      @dom.addClass    'hover'
    else
      @dom.removeClass 'hover'
