

class @main
  constructor: ->
    $W @
  Dom : =>
    @appProgress      = @found.app_progress
    @appFormOne       = @found.app_first_form
    @appFormTwo       = @found.app_two_form
    @appFormThree     = @found.app_three_form
    @defaultAppStep   = 0
    
    @fast_form =
      subjects: new $._material_select @found.fast_sub
      metro: new $._material_select @found.fast_branch

    @metroColor @fast_form.metro

    @form =
      subjects : new $._material_select @found.field_subjects
      course : new $._material_select @found.field_course
      name : @found.field_name
      phone : @found.field_phone
      comment : @found.field_comment

    @appFormLabel     = @found.form_offset_label
    @fixedHeightBlock = @found.fixed_height
  show: =>
    @found.app_next.on 'click', => Q.spawn => @changeFormStep 'next'
    @found.app_prev.on 'click', => Q.spawn => @changeFormStep 'prev'
    #@found.popup.on 'click', -> Feel.root.tree.class.attached.showForm()
    @form.name.on 'change', (e) ->Feel.urlData.set 'pupil', 'name', this.value
    @form.phone.on 'change', (e) ->Feel.urlData.set 'pupil', 'phone', this.value

    @found.send_form.on 'click', @sendFastForm
    @prepareLink @found.rew.find('a')
    $('.slide_collapse .optgroup').on 'click', (e)=>
      thisGroup = e.currentTarget
      thisGroupNumber = $(thisGroup).attr('data-group')
      thisOpen = $(thisGroup).attr('data-open')
      if thisOpen == '0'
        $('li[class*="subgroup"]').slideUp(400)
        $('.optgroup').attr('data-open', 0)
        $('.subgroup_' + thisGroupNumber).slideDown(400)
        $(thisGroup).attr('data-open', 1)
      else
        $('.subgroup_' + thisGroupNumber).slideUp(400)
        $(thisGroup).attr('data-open', 0)

    getListener  = (name) ->
      return (element) ->
        Feel.urlData.set 'pupil', name, element.val()

    sub_listener = getListener('subjects')

    @fast_form.subjects.on 'change', sub_listener
    @form.subjects.on 'change', sub_listener
    @form.course.on 'change', getListener('course')

    Q.spawn =>
      indexes = []
      for key, t of @tree.main_rep when @tree.main_rep.hasOwnProperty(key) then indexes.push t.index
      yield Feel.dataM.getTutor indexes

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


  sendFastForm: =>
    subjects = @fast_form.subjects.val()
    metro = @fast_form.metro.val()
    @found.fast_filter.attr('action', "/tutors_search?#{ yield Feel.udata.d2u 'tutorsFilter', {subjects, metro}}")
    @found.fast_filter.submit()

  metroColor : (_material_select) =>
    return unless @tree.metro_lines?
    _material_select.ul.find('li.optgroup').each (i, e) =>
      li = $(e)
      name = li.next().attr('data-value')
      return true unless name
      name = name.split(':')
      return true if name.length < 2
      return true unless @tree.metro_lines[name[0]]?
      elem = $('<i class="material-icons middle-icon">fiber_manual_record</i>')
      elem.css {color: @tree.metro_lines[name[0]].color}
      li.find('span').prepend(elem)


  getValue:  =>
    subjects : @form.subjects.val()
    course : @form.course.val()
    name : @form.name.val()
    phone : @form.phone.val()
    comment : @form.comment.val()

  setValue : (data) ->
    @form.subjects.val(data.subjects)
    @fast_form.subjects.val(data.subjects)

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

    if errs.length > 0
      Feel.sendAction 'error_on_page'

    @showError errs
    return false

  prepareLink : (a)=>
    a.filter('a').off('click').on 'click', (e)->
      link = $(this)
      index = link.attr('data-i')
      e.preventDefault()
      if index?
        Feel.main.showTutor index, link.attr 'href'
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

