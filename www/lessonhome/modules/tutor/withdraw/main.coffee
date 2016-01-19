class @main
  constructor: ->
    $W @
  Dom   : =>
    @preTrans = []
    @input = @tree.send_input.class
    @date = @tree.date.class
    @trans = @found.transations

  show  : =>
    @date.addError('wr_date', "Введите корректную дату. Пример: 21.12.2012")
    @date.addError('future', "Введенная дата не наступила")

    @input.addError('empty', "Введите значение")
    @input.addError('amount_not_num', "Введите корректоное значение")

#    @tree.save_btn.class.on 'submit', => Q.spawn @subPay
    @tree.add_btn.class.on 'submit', @addPreTrans

    @setLocalDate @trans.find('.time')

    @trans.on 'click', '.remove', ->

  setLocalDate : (time) =>
    time.each (i, e) ->
      return unless e.innerHTML
      date = new Date(e.innerHTML)
      e.innerHTML = ''
      parent = $(this.parentNode)
      parent.find('.local_date:first').text(date.toLocaleDateString()).css 'visibility', 'visible'
      parent.find('.local_time:first').text(date.toLocaleTimeString()).css 'visibility', 'visible'

  getCurr : => return parseFloat(@tree.current_sum)
  getDate : =>
    try
      date = @tree.date.class.getValue()
      return new Date() unless date
      date = date.split('.').map (e) ->
        i = parseInt(e)
        throw new Error('invalid Date') unless typeof(i) is 'number' and !isNaN(i)
        return i
      date = new Date(date[2], date[1] - 1, date[0], 10, 0, 0)
      return date
    catch errs
      return NaN

  getDesc : =>
    result = []
    result.push desc if desc = @found.desc_sel.val()
    result.push desc if desc = @tree.description.class.getValue()
    return result.join(' ')

  getForm : =>
    value : parseFloat(@tree.send_input.class.getValue())
    date : @getDate()
    description : @getDesc()
    type : @found.type.val()

  putTr : (tr, date) =>
    news = @trans.find('.new')

    if news.length == 0 or !date?
      @trans.prepend(tr)
    else
      news.each  (i, e)->
        e = $(e)

        if e.attr('data-date') <= date
          e.before(tr)
          return false

        e.after(tr) if i == news.length - 1

  addPreTrans : =>
    form = @getForm()

    if (errs = @js.check form).length
      @showError errs
      return

    tr = $("<tr class='new' data-date='#{form.date.getTime()}'>")

    tr.append("<td>-</td><td>-</td>")
    tr.append("<td><p class='local_date'>#{form.date.toLocaleDateString()}</p><i class='local_time'>#{form.date.toLocaleTimeString()}</i></td>")

    switch form.type
      when 'pay' then tr.append("<td class='down'>Списание</td>")
      when 'fill' then tr.append("<td class='up'>Пополнение</td>")
      else
        tr.append("<td>")

    tr.append("<td>#{form.value.toFixed(2)} руб.</td><td class='grey'>success</td><td>-</td>")
    tr.append("<td><a href='#' class='del'>del.</a></td>")
    @trans.find('.empty').remove()
    @putTr(tr, form.date.getTime())
    @preTrans.push form
    @input.onFocus()

  showError: (errors) =>
    for err in errors
      switch err
        when 'empty', 'amount_not_num'
          @input.showError(err)
          @input.onFocus()
        when 'wr_date', 'future'
          @date.showError(err)



#  addTr : (number, type, time, value, residue) =>
#    time = new Date time
#    tr = $('<tr class="new">')
#    summ = @found.summ
#    price_wrap =  summ.parent()
#
#    if residue >= 0
#      price_wrap.removeClass('red')
#    else
#      price_wrap.addClass('red')
#
#    residue = residue.toFixed(2)
#    summ.text(residue)
#    tr.append("<td>-</td><td>#{number}</td><td><p class='local_date'>#{time.toLocaleDateString()}</p><i class='local_time'>#{time.toLocaleTimeString()}</i></td>")
#
#    switch type
#      when 'pay' then tr.append("<td class='down'>Списание</td>")
#      when 'fill' then tr.append("<td class='up'>Пополнение</td>")
#      else
#        tr.append("<td>")
#
#    tr.append("<td>#{value.toFixed(2)} руб.</td><td>Завершено</td><td>#{residue} руб.</td>")
#    tr.append("<td><a href='#' data-number='#{number}'>del.</a></td>")
#
#    @input.setValue('')
#    body = @found.transations.find('tbody')
#    body.find('.empty').remove()
#    body.prepend(tr)
#
#  _send : (type, value) => yield @$send "./withdraw", {type, value}, 'quiet'
#
#  _addTrans : (message, type) =>
#    value = @input.getValue()
#
#    if err = @js.check value
#      @showError err
#      return
#
#    if confirm("#{message}\n\n Сумма : #{value} руб.")
#      {status, err, bill} = yield @_send(type, value)
#
#      if status == 'success'
#        @addTr bill.number, bill.type, bill.date , bill.value, bill.residue
#      else @showError err
#
#    else @input.onFocus()
#
#  fillPay : => yield @_addTrans "Пополнениe", 'fill'
#  subPay : => yield @_addTrans "Списание", 'pay'
#  delTrans : (index) =>
#
#
#  showError : (err) ->
#    @input.onFocus()
#    @input.showError(err)
