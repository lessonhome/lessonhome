class @main
  show : =>
    if @tree.hide_price
      @label = @tree.hour.class.dom.find 'label:first'
      @input = @tree.cost.class.dom.find 'input:first'
      @label.click =>
        if @label.is '.active'
          if (value = @input.val()) isnt ''
            @input.attr 'data-value', value
          @input.val ''
        else
          if (value = @input.attr 'data-value') and @input.val() is ''
            @input.val value
          @input.focus()
      @input.blur =>
        setTimeout(
          =>
            if @input.val() is ''
              @label.removeClass 'active'
            else
              @label.addClass 'active'
        , 170)