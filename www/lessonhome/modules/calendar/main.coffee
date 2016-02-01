
class @main extends EE
  Dom : =>
    @days = @found.day
    @add_time_button = @found.add_time_button
    @tags = @dom.find('.tags')
    @tag = @found.tag
    @error = @found.error
    @choose_all = @tree.choose_all.class
    #@from_time  = @tree.from_time.class
    #@till_time  = @tree.till_time.class

  show : =>
    @choose_all.on 'change', => @selectAll @choose_all.state
    @add_time_button.on 'click', => @addTime()
    @assignDaysClicksHandlers()
    @assignDeleteTagsHandlers()

    # clear error
    #@from_time.on 'focus', => @hideError()
    #@till_time.on 'focus', => @hideError()


  save : => do Q.async =>
    return false unless @check_form()
    {status,errs} = yield @$send('./save',@getData())
    if status=='success'
      return true
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
  compareTime: (first_time, second_time)=>
    first = {}
    first.separator_pos = first_time.indexOf(':', 0)
    first.hours = parseInt(first_time.substr(0, ++first.separator_pos))
    first.minutes = parseInt(first_time.substr(first.separator_pos, first_time.length - first.separator_pos))

    second = {}
    second.separator_pos = second_time.indexOf(':', 0)
    second.hours = parseInt(second_time.substr(0, ++second.separator_pos))
    second.minutes = parseInt(second_time.substr(second.separator_pos, second_time.length - second.separator_pos))


    if first.hours < second.hours
      return 1
    else
      if first.hours == second.hours
        if first.minutes > second.minutes
          return -1
        else
          if first.minutes < second.minutes
            return 1
          else
            return 0
      else
        return -1
  assignDaysClicksHandlers: =>
    for day in @days
      day = $ day
      do (day)=>
        day.click =>
          @dayClick(day)
          @error.hide()

  # handler to elements from the database

  assignDeleteTagsHandlers: =>
    tags_div = $(@tags).children()
    for tag_div in tags_div
      tag_div = $ tag_div
      do (tag_div)=>
        tag_box = tag_div.find(".tag_box")
        close_box = tag_div.find(".close_box")
        close_box.click => tag_box.parent().remove()

  getData: =>
    calendar = []
    tags_div = $(@tags).children()
    for tag_div in tags_div
      tag_div = $ tag_div
      tag = {}
      tag.day = tag_div.find(".day").text()
      tag.period = {}
      tag.period.start = tag_div.find(".time_from").text()
      tag.period.end = tag_div.find(".time_till").text()
      calendar.push tag

    return {
       calendar: calendar
    }

  # checks

  timeCheck: =>
    @from = @from_time.getValue()
    @till = @till_time.getValue()
    @select_days = []
    i = 0
    for day in @days
      day = $ day
      if day.hasClass 'active' then @select_days.push day.text()
    if !@select_days.length
      @showError 'Выберите хотя бы один день'
      return false
    if !@from
      @showError 'Заполните время'
      return false
    if !@till
      @showError 'Заполните время'
      return false
    if !@compareTime(@from, @till)
      @showError 'Пожалуйста, укажите правильно промежуток времени'
      return false
    return true
    TODO 'write a func of check'

  check_form: => true


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

  # Errors

  showError: (text)=>
    @error.show()
    @error.text(text)

  hideError: =>
    @error.text('')
    @error.hide()

  getValue : =>
    data = @getData()
    return data.calendar


