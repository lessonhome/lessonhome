
class @main
  Dom : =>
    @short_attach = @tree.short_attach.class
  show: =>
    @short_attach.addField(@found.name)
    @found.phone.mask '9 (999) 999-99-99'
    @short_attach.addField(@found.phone)
    @found.attach.on 'click', @onAttach

    @found.name.focus => @found.name.removeClass('invalid')
    @found.phone.focus => @found.phone.removeClass('invalid')
    @found.detail.click => Q.spawn => Feel.jobs.solve 'openBidPopup', 'fullBid'
    #@found.attach_pos.on    'click', => Q.spawn => Feel.jobs.solve 'openBidPopup', 'null', 'motivation'
    Q.spawn =>
      subjects = [@tree.filter.subject[0]]
      course = ((if /^(егэ|гиа)$/i.test(c) then c.toUpperCase() else c) for i, c of @tree.filter.course)
      filter = yield Feel.udata.d2u tutorsFilter : {subjects, course}
      @found.go_find.attr 'href','/search?'+filter
  onAttach : (e) => Q.spawn =>
    errs = yield @short_attach.send()

    if errs.length
      @showError(errs)
    else
      name = $(e.currentTarget).attr 'name'
      Q.spawn => Feel.sendActionOnce name
      @found.form.fadeOut  100, => @found.success.fadeIn()

    return false

  showError : (errs = []) =>

#    @found.per_err.slideUp()
    for e in errs

      if e is 'wrong_phone'
        @errInput @found.phone, 'Введите корректный телефон'
      if e is 'empty_phone'
        @errInput @found.phone, 'Введите телефон'

#      if e is 'internal_error'
#        @error.text('Внутренняя ошибка сервера. Приносим свои извенения.')
#        @found.per_err.slideDown()


  errInput: (input, error) =>

      if error?

        input.next('label').attr 'data-error', error
        parent = input.closest('.input-field')

      input.addClass('invalid')

