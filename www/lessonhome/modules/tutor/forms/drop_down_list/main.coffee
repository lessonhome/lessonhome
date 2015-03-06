class @main extends EE
  show : =>
    @label = @dom.find "label"
    @list = @label.find ".drop_down_list"
    @input = @list.find "input"


    @input.on 'focus', =>
      if @label.is '.filter_top'
        @list.addClass 'filter_top_focus'
      else
        @list.addClass 'focus'

    @input.on 'focusout', =>
      if @label.is '.filter_top'
        @list.removeClass 'filter_top_focus'
      else
        @list.removeClass 'focus'

  focusInput: =>
    @input.focus()



