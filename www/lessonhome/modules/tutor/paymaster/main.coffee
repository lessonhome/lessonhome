class @main
  Dom   : =>
    @input = @tree.send_input.class
  show  : =>
    @input.addError('empty', "Введите значение")
    @input.addError('wrong amount', "Введите корректоное значение")
    @input.addError('internal error', "Внутренняя ошибка сервера.")
#    @found.form.submit -> return false
    @tree.send_btn.class.on 'submit', @sendPay
    @setLocalDate()
    @found.trans_history.on 'click', '.short', ->
      text = $(this).find('.open')
      detail = $(this).parent().find('.detail')

      if detail.is ':visible'
        detail.stop().slideUp(300, -> text.text('подробнее'))
      else
        detail.stop().slideDown(300, -> text.text('свернуть'))

  setLocalDate : =>
    @found.trans_history.find('.time').each (i, e) ->
      return unless e.innerHTML
      date = new Date(e.innerHTML)
      parent = $(this.parentNode)
      parent.find('.local_date:first').text(date.toLocaleDateString()).css 'visibility', 'visible'
      parent.find('.local_time:first').text(date.toLocaleTimeString()).css 'visibility', 'visible'
  sendPay : =>
    try
      @tree.send_btn.class.deactive()
      value = @input.getValue()

      if err = @js.check value
        @showError(err)
        return false

      {status, err, get} = yield @$send "./sendPay", {value}, 'quiet'

      if status == 'success'
        @found.form.attr('action', get)
        @found.form.submit()
      else
        @showError(err)

      return false

    catch
      @tree.send_btn.class.active()
      return false

  showError : (err) ->
    @tree.send_btn.class.active()
    @input.onFocus()
    @input.showError(err)