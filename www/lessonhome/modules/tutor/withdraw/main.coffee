class @main
  constructor: ->
    $W @
  Dom   : =>
    @input = @tree.send_input.class
  show  : =>
    @input.addError('empty', "Введите значение")
    @input.addError('amount_not_num', "Введите корректоное значение")

    @tree.sub_btn.class.on 'submit', => Q.spawn @subPay
    @tree.fill_btn.class.on 'submit', => Q.spawn @fillPay

    @setLocalDate @found.transations.find('.time')

    @found.transations.on 'click', '.remove', ->

  setLocalDate : (time) =>
    time.each (i, e) ->
      return unless e.innerHTML
      date = new Date(e.innerHTML)
      e.innerHTML = ''
      parent = $(this.parentNode)
      parent.find('.local_date:first').text(date.toLocaleDateString()).css 'visibility', 'visible'
      parent.find('.local_time:first').text(date.toLocaleTimeString()).css 'visibility', 'visible'

  addTr : (number, type, time, value, residue) =>
    time = new Date time
    tr = $('<tr>')
    residue = residue.toFixed(2)
    tr.append("<td><p class='local_date'>#{time.toLocaleDateString()}</p><i class='local_time'>#{time.toLocaleTimeString()}</i></td>")

    switch type
      when 'pay' then tr.append("<td class='down'>Списание</td>")
      when 'fill' then tr.append("<td class='up'>Пополнение</td>")
      else
        tr.append("<td>")

    tr.append("<td>#{value.toFixed(2)} руб.</td><td>Завершено</td><td>#{residue} руб.</td>")
    tr.append("<td><a href='#' data-number='#{number}'>del.</a></td>")
    @found.summ.text(residue)
    @input.setValue('')
    body = @found.transations.find('tbody')
    body.find('.empty').remove()
    body.prepend(tr)

  _send : (type, value) => yield @$send "./withdraw", {type, value}, 'quiet'

  _addTrans : (message, type) =>
    value = @input.getValue()

    if err = @js.check value
      @showError err
      return

    if confirm("#{message}\n\n Сумма : #{value} руб.")
      {status, err, bill} = yield @_send(type, value)

      if status == 'success'
        @addTr bill.number, bill.type, bill.date , bill.value, bill.residue
      else @showError err

    else @input.onFocus()

  fillPay : => yield @_addTrans "Пополнениe", 'fill'
  subPay : => yield @_addTrans "Списание", 'pay'
  delTrans : (index) =>


  showError : (err) ->
    @input.onFocus()
    @input.showError(err)
