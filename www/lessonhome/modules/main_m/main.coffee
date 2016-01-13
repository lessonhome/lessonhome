class @main
  constructor: ->
    $W @
  Dom : =>
    @appProgress      = @found.app_progress
    @appFormOne       = @found.app_first_form
    @appFormTwo       = @found.app_two_form
    @appFormThree     = @found.app_three_form
    @defaultAppStep   = 0
    
    @form = 
      subjects : @found.field_subjects
      course : @found.field_course
      name : @found.field_name
      phone : @found.field_phone
      comment : @found.field_comment
    
    @appFormLabel     = @found.form_offset_label
    @fixedHeightBlock = @found.fixed_height
  show: =>

    @found.app_next.on 'click', => Q.spawn => @changeFormStep 'next'
    @found.app_prev.on 'click', => Q.spawn => @changeFormStep 'prev'

    @form.subjects.material_select()
    @form.course.material_select()

    @form.name.on 'change', (e) ->Feel.urlData.set 'pupil', 'name', this.value
    @form.phone.on 'change', (e) ->Feel.urlData.set 'pupil', 'phone', this.value

    @form.subjects.on 'change', (e) ->
      v = $(this).val()
      Feel.urlData.set 'pupil', 'subjects', v
      if v.length
        Feel.urlData.set 'pupil', 'subject', v[0]

    @form.course.on 'change', (e) ->
      v = $(this).val()
      Feel.urlData.set 'pupil', 'course', v

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
            @appFormThree.fadeIn 500, =>
              @appProgress.addClass 'final-step'


  getValue:  =>
    subjects : @form.subjects.val()
    course : @form.course.val()
    name : @form.name.val()
    phone : @form.phone.val()
    comment : @form.comment.val()

  setValue : (data) ->
  showError: (errs =[]) =>
    for e in errs

      if e is 'wrong_phone'
        @errInput @form.phone, 'Введите корректный телефон'
      else if e is 'empty_phone'
        @errInput @form.phone, 'Введите телефон'

      @found.fatal_error.text('')

      if e is 'internal_error'
        @found.fatal_error.text('Внутренняя ошибка сервера. Приносим свои извенения.')

  errInput: (input, error) =>

    if error?
      input.next('label').attr 'data-error', error
      parent = input.closest('.input-field')

      if parent.length and !parent.is('.err_show')
        parent.addClass('err_show')
        bottom = parent.stop(false, true).css 'margin-bottom'
        parent.animate {marginBottom: parseInt(bottom) + 17 + 'px'}, 200
        input.one 'blur', ->
          parent
            .removeClass('err_show')
            .stop().animate {marginBottom: bottom}, 200, ->
              parent
                .css 'margin-bottom', ''

    input.addClass('invalid')



  sendForm : () =>
    data = yield Feel.urlData.get 'pupil'
    data.comment = @form.comment.val()
    data = @js.takeData data
    data.linked = yield Feel.urlData.get 'mainFilter','linked'
    data.place = yield Feel.urlData.get 'mainFilter','place_attach'
    errs = @js.check(data)
    if errs.length is 0
      {status, err, errs} = yield @$send('./save', data, 'quiet')
      if status is 'success'
        Feel.sendActionOnce 'bid_popup'
        return true
      errs?=[]
      errs.push err if err

    @showError errs
    return false

  changeFormStep : (route) =>

    if @defaultAppStep != 2

      if route == 'next'
        return false if @defaultAppStep == 1 and !yield @sendForm()
        @defaultAppStep++
        @changeFormAnimation @defaultAppStep, route

      else if route == 'prev'

        if @defaultAppStep != 0
          @changeFormAnimation @defaultAppStep, route
          @defaultAppStep--

    return true

