
class @main extends EE
  show : =>
    @time_block = @dom.find ".js-show-hidden-block"
    @days = @dom.find ".calendar_week>div"
    for day in @days
      day = $ day
      do (day)=>
        day.click => @click(day, @time_block)

    @time_box = @dom.find ".time_box"
    @close = @dom.find ".close_box"
    @close.on 'click', => @closeBox






  # ######## function #########
  ###
  disable : =>
    if !@active then return
    @active = false
    @button.removeClass 'active'
    @button.addClass 'inactive'
    @emit 'disable'
  ###
  click : (day, block)=>
    if day.hasClass 'active'
      day.removeClass 'active'
      block.css('display', 'none')
      day.addClass 'hover'
    else
      day.removeClass 'hover'
      day.addClass 'active'
      block.css('display', 'block')
    @emit 'active'

  closeBox : (element)=>
    element.css('display', 'none')

