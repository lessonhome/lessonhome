
class @main extends EE
  Dom : =>
    @days = @found.day
    @add_time_button = @found.add_time_button
    @tags = @found.tags
    @tag = @found.tag
  show : =>
    @choose_all = @tree.choose_all.class
    @from_time  = @tree.from_time.class
    @till_time  = @tree.till_time.class
    @choose_all.on 'change', => @selectAll @choose_all.state

    for day in @days
      day = $ day
      do (day)=>
        day.click => @dayClick(day)

    @add_time_button.on 'click', => @addTime()

  save : => Q().then =>
    if @check_form()
      return @$send('./save',@getData())
      .then ({status,errs})=>
      if status=='success'
        return true
      #if errs?.length
        #@parseError errs
      return false
    else
      return false

  dayClick: (day)=>
    if day.hasClass 'active'
      day.removeClass 'active'
    else
      day.addClass 'active'

  selectAll: (state)=>
    if state
      for day in @days
        day = $ day
        if !day.hasClass 'active' then day.addClass 'active'
    else
      for day in @days
        day = $ day
        if day.hasClass 'active' then day.removeClass 'active'

  addTime: =>
    return false if !@check_form()
    from = @from_time.getValue()
    till = @till_time.getValue()
    select_days = []
    i = 0
    for day in @days
      day = $ day
      if day.hasClass 'active' then select_days.push day.text()

    new_tag = $(@tag).clone()
    $(new_tag).find(".day").text()
    $(new_tag).find(".time").text("c #{from} до #{till}")
    #@tags.append(@getTag(select_days[0],from,till))
    #@tags.append($(@tag).clone())
    for day in select_days
      do (day)=>
        new_tag = $(@tag).clone()
        new_tag.attr "day", day
        new_tag.attr "time_from", from
        new_tag.attr "time_till", till
        $(new_tag).find(".day").text(day)
        $(new_tag).find(".time").text("c #{from} до #{till}")
        tag_box = $(new_tag).find(".tag_box")
        close_box = $(new_tag).find(".close_box")
        $(close_box).click => $(tag_box).parent().parent().remove()
        new_tag.show()
        @tags.append(new_tag)

  getData: =>
    @calendar = []
    @tags_div = $(@tags).children()
    for tag_div in @tags_div
      tag_div = $ tag_div
      tag = {}
      if tag_div.attr("day")
        tag.day = tag_div.attr("day")
        tag.period = {}
        tag.period.start = tag_div.attr("time_from")
        tag.period.end = tag_div.attr("time_still")
        @calendar.push tag

    return {
       calendar: @calendar
    }


  # 1 если есть элемент с таким днём, то пробегаем по времени и вставляем перед нужным
  # 2 если нет, то вставляем первым после того, как пробегая по дивам значение дня оказалось больше

  check_form: =>
    return true
    TODO 'write a func of check'


  #getTag:(day, from_time, till_time)=> "<div class='tag_box'><div class='day_box'><div class='day'>#{day}</div></div><div class='time_box'><div class='time'>c #{from_time} до #{till_time}</div></div><div class='close_box'><div class='close'></div></div></div>"

  convertDay : (day)=>
    switch day
      when "пн"
        return 0
      when "вт"
        return 1
      when "ср"
        return 2
      when "чт"
        return 3
      when "пт"
        return 4
      when "сб"
        return 5
      when "вс"
        return 6
  ###
  select_days = [{day:'пн', times:["c 8 до 7", "c 9 до 10"]}, ]
  ###
  #select_days = ["0": {time_from}]

