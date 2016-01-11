class @main
  Dom : =>
    @appProgress      = @found.app_progress
    @appNext          = @found.app_next
    @appPrev          = @found.app_prev
    @appFormOne       = @found.app_first_form
    @appFormTwo       = @found.app_two_form
    @appFormThree     = @found.app_three_form
    @defaultAppStep   = 0
    @appSubject       = @found.app_subject
    @appFormLabel     = @found.form_offset_label
    @fixedHeightBlock = @found.fixed_height
  show: =>
    $(@appSubject).material_select()
    @appNext.on 'click', => @changeFormStep 'next'
    @appPrev.on 'click', => @changeFormStep 'prev'


  changeFormAnimation : (appStep, route) =>
    switch appStep
      when 1
        if route == 'next'
          @appProgress.addClass 'two-step-on'
          @appFormOne.slideUp 500
          @appFormTwo.slideDown 500
          @fixedHeightBlock.addClass 'app-form-body'
          $('html, body').animate
            scrollTop: $(@appFormLabel).offset().top
            500
        else if route == 'prev'
          @appProgress.removeClass 'two-step-on'
          @fixedHeightBlock.removeClass 'app-form-body'
          @appFormTwo.slideUp 500
          @appFormOne.slideDown 500
      when 2
        @appProgress.addClass 'tree-step-on'
        @appFormTwo.animate
          height: 0
          opacity: 0
          500
          =>
            @appFormTwo.css 'display', 'none'
            @appFormThree.fadeIn 500
  changeFormStep : (route) =>
    if @defaultAppStep != 3
      if route == 'next'
        @defaultAppStep = @defaultAppStep + 1
        @changeFormAnimation @defaultAppStep, route
      else if route == 'prev'
        if @defaultAppStep != 0
          @changeFormAnimation @defaultAppStep, route
          @defaultAppStep = @defaultAppStep - 1
