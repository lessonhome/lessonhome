class Data
  constructor: ->
    @cleanData()

  saveData : (form) ->
    index = @index
    @data[index] = form
    @index++
    @_l++
    return index

  getSaved : ->
    result = []
    for own index, data of @data then result.push data
    return result

  delData: (index) ->
    if @data[index]?
      delete @data[index]
      @_l--

  cleanData: ->
    @data = {}
    @_l = 0
    @index = 0

  exist: => @_l > 0

class TableTrans
  constructor : (table) ->
    @table = table
    @tbody = @table.find('tbody')
    @trs = @tbody.find('>tr')
    @setLocalDate()

  setLocalDate : ->
    @trs.each (i, e) =>
      tr = $(e)
      t = tr.find('.time:first')
      date = t.text()
      return unless date
      date = new Date(date)
      @setIndex tr, date.getTime()
      t.siblings('.local_date').text(date.toLocaleDateString()).css 'visibility', 'visible'
      t.siblings('.local_time').text(date.toLocaleTimeString()).css 'visibility', 'visible'

  removeTr: (selector) ->
    if selector
      @trs.filter("tr#{selector}").remove()
      @trs = @tbody.find('>tr')

      if @trs.length == 0
        @tbody.append("<tr class='empty'><td colspan='8'>Операций не обнаружено</td></tr>")


  getNewTr: (data, className) ->
    tr = $("<tr data-n='#{data.number}'>")
    tr.addClass(className) if className
    tr.append("<td>-</td><td>#{if data.number? then data.number else '-'}</td>")
    tr.append("<td><p class='local_date'>#{data.date.toLocaleDateString()}</p><i class='local_time'>#{data.date.toLocaleTimeString()}</i></td>")
    switch data.type
      when 'pay' then tr.append("<td class='down'>Спис.</td>")
      when 'fill' then tr.append("<td class='up'>Поп.</td>")
      else
        tr.append("<td>")

    tr.append("<td>#{data.value.toFixed(2)} руб.</td><td class='grey'>success</td><td class='desc'>#{data.desc}</td>")
    tr.append("<td><a href='#' class='del'>del.</a></td>")
    return tr

  addTr: (data, index, className) -> @putTr @getNewTr(data, className), index, (if className then ".#{className}" else '')

  putTr : (tr, tr_pos, among_selector) ->
    among = if among_selector then @trs.filter("#{among_selector}") else @trs
    @tbody.find('.empty').remove() if tr.length

    if among.length == 0 or !tr_pos?
      @tbody.prepend(tr)
    else
      among.each  (i, e)=>
        e = $(e)

        if @getIndex(e) <= tr_pos
          e.before(tr)
          return false

        e.after(tr) if i == among.length - 1

    @setIndex(tr, tr_pos)
    @trs = @trs.add(tr)
    return tr

  setIndex : (tr, index) -> tr.attr('data-tr_pos', index)
  getIndex: (tr) -> parseInt(tr.attr('data-tr_pos'))

class CurrentPrice
  constructor: (elem, value=0) ->
    @elem = elem
    @sum = @elem.find('.summ')
    @curr = value
  get : -> @curr
  set : (val) ->
    return if isNaN val
    val = val.toFixed(2)
    @sum.text(val)

    if val < 0
      @elem.addClass('red')
    else
      @elem.removeClass('red')

class @main
  constructor: ->
    $W @
  Dom   : =>
    @added = new Data
    @input = @tree.send_input.class
    @date = @tree.date.class
    @trans = @found.transations
    @table = new TableTrans @trans.closest('table')
    @price = new CurrentPrice $('.summ_price:first'), @tree.current_sum
  show  : =>
    @date.addError('invalid date', "Введите корректную дату. Пример: 21.12.2012")
    @date.addError('future date', "Введенная дата не наступила")

    @input.addError('empty', "Введите значение")
    @input.addError('wrong amount', "Введите корректоное значение")

#    @tree.save_btn.class.on 'submit', => Q.spawn @subPay
    @tree.add_btn.class.on 'submit', @addTrans
    @tree.save_btn.class.on 'submit', @saveTrans

    @found.desc_sel.on 'change', =>
      @tree.description.class.input.trigger('focus')
      type = @found.desc_sel.find('option:selected').attr('data-type')
      if type
        @found.type.prop('disabled', true).val(type)
      else
        @found.type.prop('disabled', false)

    @trans.on 'click', 'a.del', (e) =>
      Q.spawn =>
        tr = $(e.currentTarget).closest('tr')

        if tr.is '.new'

          if index = tr.attr('data-i')
            @table.removeTr("[data-i=#{index}]")
            @added.delData(index)

        else
          number = tr.attr 'data-n'

          if number
            tr.addClass('ready')

            if confirm("Удалить транзакцию № #{number}?")
              {status, residue,err} = yield @$send './withdraw', {number, type: 'del'}, 'quiet'

              if status == 'success'
                @table.removeTr("[data-n=#{number}]")
                @price.set(residue)

            tr.removeClass('ready')



      return false

  addTrans : =>
    @found.error.text('')
    form = @getForm()

    if (errs = @js.check form).length
      @showError errs
      return

    tr = @table.addTr(form,form.date.getTime(), 'new')
    tr.attr('data-i', @added.saveData(form))
    @resetForm(false)

  saveTrans : ->
    data = @added.getSaved()

    if @added.exist()

      if @js.validTrans(data)

        if confirm("Сохранить добавленные транзакции: \n" + @transToString(data))
          {status, data, err} = yield @$send('./withdraw', {type: 'save', data}, 'quiet')

          if status == 'success'
            @added.cleanData()
            @table.removeTr '.new'

            for number, v of data.added
              v['number'] = number
              v.date = new Date(v.date)
              @table.addTr v, v.date.getTime()

            @price.set(data.residue)

          else
            @showError [err]

      else
        @showError(['wrong data'])

    else
      @input.onFocus()

  transToString: (trans) =>
    str = ''
    for t in trans

      switch t.type
        when 'fill'
          str += "Внести "
        when 'pay'
          str += "Списать "
        else
          str += "Неизвестная операция"

      str += t.value.toFixed(2) + ' руб. \n'

    return str

  showError: (errors) =>
    for err in errors
      switch err
        when 'empty', 'wrong amount'
          @input.showError(err)
          @input.onFocus()
        when 'invalid date', 'future date'
          @date.showError(err)
        when 'type not exist'
          @found.error.text("Выберите тип операции")
        else
          @found.error.text(err)


  getDate : =>
    try
      now  = new Date
      date = @tree.date.class.getValue()
      return now unless date
      date = date.split('.').map (e) ->
        i = parseInt(e)
        throw new Error('invalid Date') if isNaN(i)
        return i
      now.setDate(date[0])
      now.setFullYear(date[2])
      now.setMonth(date[1] - 1)
      return now
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
    desc : @getDesc()
    type : @found.type.val()

  resetForm: (all = true) ->

    if all
      @tree.date.class.setValue('')

    @found.type.prop('disabled', false).val('')
    @input.setValue('')
    @found.desc_sel.val('')
    @tree.description.class.setValue('')


