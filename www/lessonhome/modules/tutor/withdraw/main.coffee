class @main
  Dom   : =>
    @input = @tree.send_input.class
  show  : =>
    @input.addError('wrong', "Введите корректоное значение")

    @tree.sub_btn.class.on 'submit', @sendPay
    @tree.fill_btn.class.on 'submit', @FillPay

    @setLocalDate @found.transations.find('.time')

  setLocalDate : (time) =>
    time.each (i, e) ->
      return unless e.innerHTML
      date = new Date(e.innerHTML)
      e.innerHTML = ''
      parent = $(this.parentNode)
      parent.find('.local_date:first').text(date.toLocaleDateString()).css 'visibility', 'visible'
      parent.find('.local_time:first').text(date.toLocaleTimeString()).css 'visibility', 'visible'

  addTr : (time, value, residue) =>
    time = new Date time
    tr = $('<tr>')
    residue = residue.toFixed(2)
    tr.append("<td><p class='local_date'>#{time.toLocaleDateString()}</p><i class='local_time'>#{time.toLocaleTimeString()}</i></td>")
    tr.append("<td class='down'>Списание</td><td>#{value.toFixed(2)} руб.</td><td>Завершено</td><td>#{residue} руб.</td>")
    tr.append("<td><a href=''#'>del</a></td>")
    @found.summ.text(residue)
    @input.setValue('')
    @found.transations.find('tbody>tr:first-child').after(tr)

  sendPay : =>
    value = @input.getValue()
    if err = @js.check value
      @showError err
      return
    if confirm("Подтвердите факт списания средств\n\n Сумма : #{value} руб.")
      {status, err, bill} = yield @$send "./withdraw", {value}
      if status == 'success'
        @addTr bill.date , bill.value, bill.residue
      else @showError err
    else @input.onFocus()

  @FillPay : =>


  showError : (err) ->
    @input.onFocus()
    @input.showError(err)
