
class @main extends EE
  Dom : =>
    @choose_all = @found.choose_all
    @days = @found.calendar_week.children()
    @add_time = @found.add_time_button
    @tag = @found.tag
  show : =>
    @choose_all.click => @select_all

    for day in @days
      day = $ day
      do (day)=>
        day.click => @dayClick(day)

    @add_time.on 'click', =>
      #$(@tags).append(@new_tag)
      #$('body').append(@new_tag.dom)
      #console.log @new_tag.dom

  dayClick: (day)=>
    if day.hasClass 'active'
      day.removeClass 'active'
    else
      day.addClass 'active'

  select_all: ()=>
    for day in @days
      day = $ day
      if day.hasClass 'active'
        day.removeClass 'active'
      else
        day.addClass 'active'















