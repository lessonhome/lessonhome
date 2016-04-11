class @main
  constructor: ->
    $W @
  Dom : =>
    @short_form = @tree.short_form.class
    @error = @found.fatal_error
    @per_err = @error.closest('.row')

  show: =>

    @short_form.addField(@found.name)
    @short_form.addField(@found.phone)

    @found.detail.on    'click', => Q.spawn => Feel.jobs.solve 'openBidPopup', 'fullBid', @tree.param_popup
    @found.send.on      'click', @onSend

  onSend : => Q.spawn =>
    errs = yield @short_form.send()

    if errs.length
      @showError errs
      return false

    @found.short_form.fadeOut 200, => @found.success_form.fadeIn()
    return true


  showError: (errs =[]) =>
    @per_err.slideUp()
    for e in errs

      if e is 'wrong_phone'
        @errInput @found.phone, 'Введите корректный телефон'
      if e is 'empty_phone'
        @errInput @found.phone, 'Введите телефон'

      if e is 'internal_error'
        @error.text('Внутренняя ошибка сервера. Приносим свои извенения.')
        @per_err.slideDown()

  errInput: (input, error) =>

    if error?
      input.next('label').attr 'data-error', error
      parent = input.closest('.input-field')

    input.addClass('invalid')

  setValue : (data) =>
    @found.name.val(data.name)
    @found.phone.val(data.phone)
  getValue : =>
    name : @found.name.val()
    phone : @found.phone.val()
