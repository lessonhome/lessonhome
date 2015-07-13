class @main extends EE
  Dom : =>

    @extra = @found.extra
    @extra_filters_button_wrap = @found.extra_filters_button_wrap
    # buttons
    @show_extra_filters = @found.show_extra_filters
    @cancel_button = @found.cancel_button
    @apply_filters_button = @found.apply_filters_button
  show : =>
    $(@show_extra_filters).on 'click', =>
      @extra.show()
      @extra_filters_button_wrap.addClass 'show'
      @show_extra_filters.hide()

    $(@cancel_button).on 'click', =>
      @extra.hide()
      @extra_filters_button_wrap.removeClass 'show'
      @show_extra_filters.show()

    $(@apply_filters_button).on 'click', =>
      @extra.hide()
      @extra_filters_button_wrap.removeClass 'show'
      @show_extra_filters.show()



