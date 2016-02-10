

class @main
  constructor: ->
    $W @
  Dom : =>
    @appProgress      = @found.app_progress
    @appFormOne       = @found.app_first_form
    @appFormTwo       = @found.app_two_form
    @appFormThree     = @found.app_three_form
    @defaultAppStep   = 0
    @slickBlock       = @found.slick_block

    @slickBlock.slick({
      dots: false,
      infinite: true,
      slidesToShow: 4,
      slidesToScroll: 4,
      responsive: [
        {
          breakpoint: 1000,
          settings: {
            infinite: true,
            slidesToShow: 2,
            slidesToScroll: 2
          }
        },
        {
          breakpoint: 480,
          settings: {
            infinite: true,
            slidesToShow: 1,
            slidesToScroll: 1
          }
        }
      ]
    })
    @form = {
      name : @found.name
      phone : @found.phone
    }

    @fast_form =
      subjects: new $._material_select @found.fast_sub
      metro: new $._material_select @found.fast_branch

    @metroColor @fast_form.metro

    @appFormLabel     = @found.form_offset_label
    @fixedHeightBlock = @found.fixed_height
    @error = @found.fatal_error
    @per_err = @error.closest('.row')
  show: =>

    getListener  = (name, element) -> -> Feel.urlData.set 'pupil', name, element.val()

    @fast_form.subjects.on 'change', getListener('subjects', @fast_form.subjects)
    @form.name.on          'change', getListener('name', @form.name)

    phone_listen = getListener('phone', @form.phone)
    @form.phone.on 'change', (e) =>
      phone_listen()
      Q.spawn => @sendForm(true)

    @found.detail.on    'click', => Q.spawn => Feel.jobs.solve 'openBidPopup', 'fullBid', 'motivation'
    @found.attach.on    'click', => Q.spawn => Feel.jobs.solve 'openBidPopup', null, 'motivation'
    @found.send.on      'click', => Q.spawn => @sendForm()
    @found.send_form.on 'click', => Q.spawn => @sendFastForm()


    @prepareLink @found.rew.find('a')

    Q.spawn =>
      indexes = []
      for own key, t of @tree.main_rep then indexes.push t.index
      yield Feel.dataM.getTutor indexes

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
    name : @form.name.val()
    phone : @form.phone.val()

  setValue : (data) ->
    @form.name.val(data.name).focusin().focusout()
    @form.phone.val(data.phone).focusin().focusout()
    @fast_form.subjects.val(data.subjects)


  sendForm : (quiet = false) =>
    data = yield Feel.urlData.get 'pupil'
#    data.comment = @form.comment.val()
    #    data = @js.takeData data
    data.linked = yield Feel.urlData.get 'mainFilter','linked'
    data.place = yield Feel.urlData.get 'mainFilter','place_attach'
    errs = @js.check(data)

    if errs.length is 0
      {status, err, errs} = yield @$send('./save', data, quiet && 'quiet')

      if status is 'success'
        Feel.sendActionOnce 'bid_popup'
        #        url = History.getState().hash
        #        url = url?.replace?(/\/?\?.*$/, '')
        Feel.sendActionOnce 'bid_action', null, {name: 'main'}

        unless quiet
          @found.short_form.fadeOut 200, => @found.success_form.fadeIn()

        return true

      errs?=[]
      errs.push err if err

    Feel.sendAction 'error_on_page'
    @showError errs unless quiet
    return false


  showError: (errs =[]) =>
    @per_err.slideUp()
    for e in errs

      if e is 'wrong_phone'
        @errInput @form.phone, 'Введите корректный телефон'
      if e is 'empty_phone'
        @errInput @form.phone, 'Введите телефон'

      if e is 'internal_error'
        @error.text('Внутренняя ошибка сервера. Приносим свои извенения.')
        @per_err.slideDown()

  errInput: (input, error) =>

    if error?
      input.next('label').attr 'data-error', error
      parent = input.closest('.input-field')

#      if parent.length and !parent.is('.err_show')
#        parent.addClass('err_show')
#        bottom = parent.stop(false, true).css 'margin-bottom'
#        parent.animate {marginBottom: parseInt(bottom) + 17 + 'px'}, 200
#        input.one 'blur', ->
#          parent
#            .removeClass('err_show')
#            .stop().animate {marginBottom: bottom}, 200, ->
#              parent
#                .css 'margin-bottom', ''

    input.addClass('invalid')

  prepareLink : (a)=>
    a.filter('a').off('click').on 'click', (e)->
      link = $(this)
      index = link.attr('data-i')
      e.preventDefault()
      if index?
        Feel.main.showTutor index, link.attr 'href'
      return false
