class @main extends EE
  Dom : =>
    @calendar_week = @found.calendar_week
    @day_time = @tree.day_time
    console.log @day_time
    @week = {'пн':'0', 'вт':'1', 'ср':'2', 'чт':'3', 'пт':'4', 'сб':'5', 'вс':'6'}
  show : =>
    for key,val of @day_time
      @setActiveDay @week[val.day]

  setActiveDay : (day_number)=>
    @days = @calendar_week.children()
    day = $(@days[day_number])
    return if day.hasClass 'active'
    day.addClass 'active'
    return true