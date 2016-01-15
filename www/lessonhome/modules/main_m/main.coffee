class _material_select extends EE
  LI = 'li:not(.optgroup)'
  constructor : (jQelem) ->
    @_sort = {}
    @elem = jQelem
    @is_multi = @elem[0].multiple
    @value = null
    @_default = "ds"
    @elem.find('option').each (i, e) =>
      o = $(e)
      v = o.attr('value')
      if v.length
        o.text(o.text() + "\#\{#{v}\}")
      else
        @_default = o.text()

    @elem.material_select()
    @ul = @elem.siblings('ul').on('mouseup touchend', LI, @_change)
    regexp = /^(.+)#{(.+)}$/
    @lis = @ul.find(LI)
    .each (i, li) =>
      li = $(li)
      textNode = @_getTextNode(li)
      text = textNode.text()
      text = text.match regexp

      if text?[1]? and text[2]?

        textNode[0].data = text[1]

        li.attr('data-value', text[2])
        @_sort[text[2]]?= {n:text[1], el:[]}
        @_sort[text[2]].el.push li

    @input = @elem.siblings('input')

    if @is_multi then @_preload()

    regexp = /#{.+}$/

    setTimeout =>
      @elem.find('option').each ->
        o = $(this)
        o.text(o.text().replace(regexp, ''))
    ,200

  _preload : =>
    exist = {}
    result = []
    for v in @elem.val() when not exist[v]
      exist[v] = true
      result.push v
    @val result

  _change : (e) =>
    li = $(e.currentTarget)
    name = li.attr('data-value')

    setTimeout =>
      if @_sort[name]?.el?.length > 1
        @_setCheckedLi(l, li.is '.active') for l in @_sort[name].el

      @value = @_getSelectedValues()
      @elem.val(@value)
      @_updateInput()
      @emit 'change'
    ,0

    return true

  _getTextNode : (li) ->
    return li.find('span').contents().filter(-> return this.nodeType == 3)

  _setCheckedLi : (li, check = true) ->
    return if check == li.is '.active'
    if check then li.addClass('active') else li.removeClass('active')
    li.find('input[type="checkbox"]:first').prop('checked', check)

  _getSelectedValues : ->
    exist = {}
    $.map @lis, (li) =>
      li = $(li)
      val = li.attr('data-value')
      return if exist[val] or not li.is('.active')
      exist[val] = true
      return val

  _updateInput : ->
    value = @value.map (e) => @_sort[e].n
    @input[0].value = value.join(', ') || @_default

  _resetAllSelected : -> @lis.each (i, e) => @_setCheckedLi $(e), false

  val : (value) ->
    return @value unless value?
    @_resetAllSelected()
    @elem.val value
    @value = if value instanceof Array then value else [value]
    @_chekByArrValues(@value)
    @elem.trigger 'change'
    @_updateInput()
    return @elem

  _chekByArrValues : (values) -> @checkByValue(v) for v in values
  checkByValue : (name, check = true) ->
    if @_sort[name]?.el?
      @_setCheckedLi(li, check) for li in @_sort[name].el


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
      subjects : new _material_select @found.field_subjects
      course : new _material_select @found.field_course
      name : @found.field_name
      phone : @found.field_phone
      comment : @found.field_comment

    @appFormLabel     = @found.form_offset_label
    @fixedHeightBlock = @found.fixed_height
  show: =>

    @found.app_next.on 'click', => Q.spawn => @changeFormStep 'next'
    @found.app_prev.on 'click', => Q.spawn => @changeFormStep 'prev'
    @found.popup.on 'click', -> Feel.root.tree.class.attached.showForm()
    @form.name.on 'change', (e) ->Feel.urlData.set 'pupil', 'name', this.value
    @form.phone.on 'change', (e) ->Feel.urlData.set 'pupil', 'phone', this.value

    @prepareLink @found.rew.find('a')

    @form.subjects.ul.find('.optgroup').on 'click', (e)=>
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


    @form.subjects.on 'change', =>
      v = @form.subjects.val()
      Feel.urlData.set 'pupil', 'subjects', v
      if v.length
        Feel.urlData.set 'pupil', 'subject', v[0]

    @form.course.on 'change', =>
      v = @form.course.val()
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

  prepareLink : (a)=>
    a.filter('a').off('click').on 'click', (e)->
      link = $(this)
      index = link.attr('data-i')
      e.preventDefault()
      if index?
        Feel.main.showTutor index, $(this).attr 'href'
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

