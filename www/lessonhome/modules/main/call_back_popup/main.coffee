

class @main extends EE
  Dom: =>
    @popup = @found.popup
    @pupil = @tree.pupil.class
    @tutor = @tree.tutor.class
    @order_call = @tree.order_call.class
    @your_name  = @tree.your_name.class
    @tel_number = @tree.tel_number.class
    @comments   = @tree.comments.class
    @err_type = @found.out_err_type

  show: =>
    @pupil.on 'active', =>
      @tutor.disable()
      $(@err_type).hide()
    @tutor.on 'active', =>
      @pupil.disable()
      $(@err_type).hide()

    @order_call.on 'submit', @b_call


  b_call : => do Q.async =>
    success = yield @save()
    if success
      $(@popup).html('Спасибо! Вам скоро перезвонят!')
      @emit 'sent'
  save : => do Q.async =>
    if @check_form()
      return @onReceive yield @$send('./save',@getData())
    else
      return false

  onReceive : ({status,errs,err})=>
    if err?
      errs?=[]
      errs.push err
    if status=='success'
      Feel.sendAction 'back_call'
      return true
    if errs?.length
      Feel.sendAction 'error_on_page'
      for e in errs
        @parseError e
    return false

  check_form : =>
    errs = @js.check @getData()
    #if !@tel_number.doMatch() then errs.push "bad_phone"
    #for e in errs
    #  @parseError e
    return errs.length==0

  getData : =>
    @type = 'unselect'
    if @pupil.active then @type = 'pupil'
    if @tutor.active then @type = 'tutor'
    return {
    your_name:  @your_name.getValue()
    tel_number: @tel_number.getValue()
    comments:   @comments.getValue()
    type:       @type
    }

  parseError : (err)=>
    switch err
    #short
      when "short_your_name"
        @your_name.showError "Слишком короткое имя"
    #empty
      when "empty_your_name"
        @your_name.showError "Заполните имя"
      when "empty_type"
        $(@err_type).show()
        $(@err_type).text("выберите значение")
      when "bad_phone"

      else
        alert 'die'

