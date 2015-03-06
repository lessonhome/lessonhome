
class @main extends EE
  show : =>
    @days = @dom.find(".calendar_week").children()
    @add_button = @dom.find ".add_time"
    @tags = @dom.find ".tags"
    @new_tag = @tree.new_tag.class
    @select_days = []
    for day in @days
      day = $ day
      do (day)=>
        day.click => @dayClick(day)

    @add_button.on 'click', =>
      #$(@tags).append(@new_tag)
      #$('body').append(@new_tag.dom)
      console.log @new_tag.dom

  dayClick: (day)=>
    console.log day
    if day.hasClass 'active'
      day.removeClass 'active'
    else
      day.addClass 'active'
