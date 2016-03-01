class @main
  constructor: ->
    $W @
    @listeners : {}
#    @form.phone.mask '9 (999) 999-99-99'
#    @found.detail.on    'click', => Q.spawn => Feel.jobs.solve 'openBidPopup', 'fullBid', @tree.param_popup
#    @found.send.on      'click', => Q.spawn => @sendForm()

#    getListener  = (name, element) -> ->
#
#
#    @form.name.on          'change', getListener('name', @form.name)
#
#    phone_listen = getListener('phone', @form.phone)
#    @form.phone.on 'change', (e) =>
#      phone_listen()
#

  @makeListener : (listener, name) =>
    name = field.attr('name') unless name?
    return false unless name?
    throw new Error('wrong listener') unless listener instanceof jQuery
    @listeners[name]?=[]
    @listeners[name].push listener

  _execute : (data) =>
    for own name, l of @listeners

      if data[name]?
        listener.val(data[name]) for listener in l


  say: => console.log 'hello'
  setVal : (name, val = '') =>
    return false unless name
    yield Feel.sendActionOnce('interacting_with_form', 1000*60*10)
    yield Feel.urlData.set 'pupil', name, field.val()
    if name == 'phone'
      Q.spawn => @sendForm(true)

  send : (quiet = false) =>
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
        url = yield Feel.urlData.getUrl true
        url = url?.replace?(/\/?\?.*$/, '')
        Feel.sendActionOnce 'bid_action', null, {name: @tree.param_popup, url}
        return true

      errs?=[]
      errs.push err if err

    return errs

#  showError: (errs =[]) =>
#    @per_err.slideUp()
#    for e in errs
#
#      if e is 'wrong_phone'
#        @errInput @form.phone, 'Введите корректный телефон'
#      if e is 'empty_phone'
#        @errInput @form.phone, 'Введите телефон'
#
#      if e is 'internal_error'
#        @error.text('Внутренняя ошибка сервера. Приносим свои извенения.')
#        @per_err.slideDown()

#  errInput: (input, error) =>
#
#    if error?
#      input.next('label').attr 'data-error', error
#      parent = input.closest('.input-field')
#
#    #      if parent.length and !parent.is('.err_show')
#    #        parent.addClass('err_show')
#    #        bottom = parent.stop(false, true).css 'margin-bottom'
#    #        parent.animate {marginBottom: parseInt(bottom) + 17 + 'px'}, 200
#    #        input.one 'blur', ->
#    #          parent
#    #            .removeClass('err_show')
#    #            .stop().animate {marginBottom: bottom}, 200, ->
#    #              parent
#    #                .css 'margin-bottom', ''
#
#    input.addClass('invalid')

  setValue : (data) =>
    @form.name.val(data.name).focusin().focusout()
    @form.phone.val(data.phone).focusin().focusout()

  getValue : =>
    name : @form.name.val()
    phone : @form.phone.val()
