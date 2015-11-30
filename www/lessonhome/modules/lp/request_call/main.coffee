

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

    @show_error = {
      reset : =>
        @tel_number.removeClass('invalid')
        @your_name.removeClass('invalid')
      wrong_phone : ->  this.show_err(@tel_number, 'Введите корректный телефон')
      empty_phone : -> this.show_err(@tel_number, 'Введите телефон')
      empty_name : ->

      show_err : (fld, message) ->
        fld.addClass('invalid').siblings('label').attr('data-error', message)
    }

  show: =>
#    @pupil.on 'active', =>
#      @tutor.disable()
#      $(@err_type).hide()
#    @tutor.on 'active', =>
#      @pupil.disable()
#      $(@err_type).hide()

    @order_call.on 'click', => Q.spawn => @b_call()
    @found.req_call_modal.on 'ready', -> console.log 'hello'

  b_call : =>
    if yield @save()
      @showSuccess()
#    if success
#      $(@popup).html('Спасибо! Вам скоро перезвонят!')
#      @emit 'sent'

  showSuccess : =>
    @found.wrap.css {
      minHeight: @found.success.outerHeight(true)
    }
    @found.form.animate({opacity: '0'}).slideUp 100, => @found.success.fadeIn()
  save : => do Q.async =>
    data = @getData()
    return false unless @check_form(data)
    return @onReceive yield @$send('./save', data)

  check_form : (data) =>
    err = @js.check(data)
    @resetError()
    for e in err
      @parseError(e)
    return err.length == 0

  resetError : =>
    @tel_number.removeClass('invalid')
    @your_name.removeClass('invalid')

  onReceive : ({status,errs,err})=>
    console.log 'status', status
    if err?
      errs?=[]
      errs.push err
    if status=='success'
      Feel.sendAction 'back_call'
      return true
    if errs?.length
      for e in errs
        @parseError e
    return false

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


