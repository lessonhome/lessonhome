class @main extends EE
  show : =>
    @first_value = @found.first_value
    @second_value = @found.second_value
    @toggle_block = @found.toggle_block

    @first_value.on 'click', => @value_click(@first_value, @second_value, @toggle_block, @first_value)
    @toggle_block.on 'click', => @toggle_block_click(@first_value, @second_value, @toggle_block)
    @second_value.on 'click', =>
      @value_click(@first_value, @second_value, @toggle_block, @second_value)
      @emit 'sec_active'
    if @tree.value?
      if @tree.value
        @value_click(@first_value, @second_value, @toggle_block, @first_value)
      else
        @value_click(@first_value, @second_value, @toggle_block, @second_value)
  value_click: (first_value, second_value, toggle_block, element)=>
    if element.hasClass("active_value")
      return 0
    else
      @change_toggle_activities(toggle_block)
      @change_values_activities(first_value, second_value)

  toggle_block_click: (first_value, second_value, toggle_block)=>
    @change_toggle_activities(toggle_block)
    @change_values_activities(first_value, second_value)

  change_values_activities: (first_value, second_value)=>
    if first_value.hasClass("active_value")
      first_value.removeClass("active_value")
      second_value.addClass("active_value")
    else
      second_value.removeClass("active_value")
      first_value.addClass("active_value")

  change_toggle_activities: (toggle_block)=>
    if toggle_block.hasClass("active_toggle")
      toggle_block.removeClass("active_toggle")
      @emit 'sec_active'
    else toggle_block.addClass("active_toggle")

  getValue: =>
    if @first_value.hasClass("active_value")
      return true
    else
      return false

