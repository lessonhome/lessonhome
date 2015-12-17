
class @main
  constructor: ->
    $W @
  Dom : =>
    @input = @tree.code.class
    @btn_send_again = @found.again
    @btn_continue = @tree.continue_button.class
  show: =>
    @btn_send_again.on 'click', @onSendAgain
    @btn_continue.on 'submit', @onSend
    yield @updateBtn()
  onSendAgain : (e) => Q.spawn =>
    btn = $(e.currentTarget)
    return if btn.is '.disabled'
    {status} = yield @$send 'passwordRestore'
    if status == 'success'
      btn.addClass('disabled')
      yield @updateBtn()

  onSend : => Q.spawn =>
    if (value = @input.getValue())
      {status,err, token} = yield @$send './sendCode', {code: value}
      console.log token, err,status
      if status == 'success' and token?
        return Feel.go '/new_password?' + token
      else if status =='failed' and err? then @showError(err)
    else
      @showError('empty_code')

  updateBtn : =>
    {status, err, time} = yield @$send './getTime'

    if status == 'success'
      if time > 0
        setTimeout =>
          Q.spawn =>
            yield @updateBtn()
        , time
      else
        @btn_send_again.removeClass('disabled')


  showError : (err)=>
    switch err
      when 'empty_code'
        @input.showError('Введите код подтверждения')
      when 'not_exist'
        @input.showError('Сообщение не было отправлено')
      when 'timeout'
        @input.showError('Срок дейсвия кода истек')
      when 'wrong_code'
        @input.showError('Неверный код. Пожалуйста, проверте правильность заполнения')
      else
        @input.showError('Внутренняя ошибка сервера')
