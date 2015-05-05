
class @main extends EE
  Dom : =>
    @days = @found.day
    @add_time_button = @found.add_time_button
    @tags = @found.tags
    @tag = @found.tag
    @error = @found.error
    @choose_all = @tree.choose_all.class
    @from_time  = @tree.from_time.class
    @till_time  = @tree.till_time.class

  show : =>
    @choose_all.on 'change', => @selectAll @choose_all.state
    @add_time_button.on 'click', => @addTime()
    @assignDaysClicksHandlers()
    @assignDeleteTagsHandlers()

    # clear error
    @from_time.on 'focus', => @hideError()
    @till_time.on 'focus', => @hideError()


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
    return false if !@timeCheck()
    @from = @from_time.getValue()
    @till = @till_time.getValue()
    @from_time.setValue('')
    @till_time.setValue('')

    for day in @select_days
      do (day)=>
        new_tag = @newTag(day)
        #@insertTag
        day_number = @convertDay day
        day_time_from_int = parseInt(@from.substr(0,2), 10)
        console.log day_number
        tags_div = $(@tags).children()
        console.log tags_div
        for tag_div in tags_div
          tag_div = $ tag_div
          tag_div_day_number = @convertDay tag_div.find(".day").text()
          if day_number < tag_div_day_number
            new_tag.insertBefore(tag_div)
            return true
          else
            if day_number == tag_div_day_number
              if !@compareTime(@from, tag_div.find(".time_from").text())
              #if day_time_from_int <= parseInt(tag_div.find(".time_from").text().substr(0,2), 10)
                new_tag.insertBefore(tag_div)
                return true

        @tags.append(new_tag)

  newTag: (day)=>
    new_tag = @tag.clone()
    new_tag.show()
    new_tag.find(".day").text(day)
    new_tag.find(".time_from").text(@from)
    new_tag.find(".time_till").text(@till)
    tag_box = new_tag.find(".tag_box")
    close_box = new_tag.find(".close_box")
    close_box.click => tag_box.parent().remove()
    return new_tag

  # compare two time format "9:05"
  # return true if first time more than second or equal and false if second bigger
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
      return true
    else
      if first.hours == second.hours
        if first.minutes >= second.minutes
          return true
        else
          return false
      else
        return true

  # handlers

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
    @select_days = []
    i = 0
    for day in @days
      day = $ day
      if day.hasClass 'active' then @select_days.push day.text()
    if !@select_days.length
      @showError 'Выберите хотя бы один день'
      return false
    if !@from_time.getValue()
      @showError 'Заполните время'
      return false
    if !@till_time.getValue()
      @showError 'Заполните время'
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


