

class @main extends EE
  Dom: =>
#    @popup = @found.popup
#    @pupil = @tree.pupil.class
#    @tutor = @tree.tutor.class

    @order_call = @found.order_call
    @your_name  = @found.your_name
    @tel_number = @found.tel_number
    @comments   = @found.comments
#    @err_type = @found.out_err_type

  show: =>
#    @pupil.on 'active', =>
#      @tutor.disable()
#      $(@err_type).hide()
#    @tutor.on 'active', =>
#      @pupil.disable()
#      $(@err_type).hide()

    @order_call.on 'click', => Q.spawn => @b_call()

  b_call : =>
    result = yield @save(true)

    if result.status == 'success'
      @showSuccess()
#      setTimeout @showForm, 3000
    else
      @showError result.errs


  showSuccess : =>
    @resetError()
    @found.wrap.css 'min-height',  @found.success.css('opacity', '1').outerHeight(true)
    @found.form.animate {opacity: '0'}, 150, => @found.success.fadeIn()
    @found.form.slideUp 150

  showForm : =>
    @comments.val('')
    @found.success.animate {opacity: '0'}, 150
    @found.form.animate {opacity: '1'}, 150
    @found.form.slideDown(150, =>
      @found.success.hide()
      @found.wrap.css 'min-height', ''
    )

  check_form : () =>
    data = @getData()
    err = @js.check(data)
    @showError(err)
    return err.length == 0

  save : (show_er = false) => do Q.async =>
    data = @getData()
    errs = @js.check(data)

    if errs.length
      return show_er && {status: 'failed', errs}

    r = yield @$send('./save', data)

    if r.status == 'success'
      Feel.sendAction 'back_call'
    else
      return show_er && r

    return r

  resetError : =>
    @tel_number.removeClass('invalid')
    @your_name.removeClass('invalid')

  showError : (errs) =>
    @resetError()
    for e in errs
      @parseError(e)

  getData : =>
    @type = 'unselect'
#    if @pupil.active then @type = 'pupil'
#    if @tutor.active then @type = 'tutor'
    return {
      your_name:  @your_name.val()
      tel_number: @tel_number.val()
      comments:   @comments.val()
      type:       @type
    }

  parseError : (err)=>
    switch err
      when "empty_name"
        @errField @your_name, "Введите имя"
      when "empty_phone"
        @errField @tel_number, "Введите телефон"
      when "wrong_phone"
        @errField @tel_number, "Введите корректный телефон"


  errField : (field, err) =>
    field.addClass('invalid').siblings('label').attr('data-error', err)


