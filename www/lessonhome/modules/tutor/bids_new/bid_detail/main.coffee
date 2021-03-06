class History
  constructor : (elem) ->
    @elem = elem
    @id_bid = elem.attr('data-id')
    @elem.find('ul:first').on 'click', 'a.close', @onRemLog
    @elem.find('.add:first').click @onAddLog

  onRemLog: (e) =>

    if confirm("Удалить запись?")
      Q.spawn =>
        li = $(e.currentTarget).closest('li')
        {status} = yield Feel.jobs.server 'remLog', {
          id : @id_bid
          index : @elem.find('ul:first li').index(li)
        }

        if status == 'success'
          li.remove()

    return false

  onAddLog: (e) =>
    Q.spawn =>
      input = @elem.find('input[type=text]')
      desc = input.val()

      if desc
        {status} = yield Feel.jobs.server 'addLog', {id: @id_bid, desc}

        if status == 'success'
          input.val('')
          @_addHistory desc
    return false

  _addHistory : (text) =>
    @elem.find('ul:first').append "
      <li>
        <i>#{new Date().toLocaleDateString()}</i>
        <a href='#' class='close'>&times</a>
        <p>#{text}</p>
      </li>
    "


class @main
  Dom : =>
    @sub = @tree.subjects.class
    @income = null
  show: =>
    @sub.setValue @tree.value.subjects ? [@tree.value.subject]
#    @dom.find("a.show").on 'click', @onShowDetail
#    @found.make.on 'click', @onMakeExecutor
    @found.save.click @onSaveChange

    @found.commision.on 'change', 'input[type=text]', (e) =>
      el = $(e.currentTarget)
      console.log 'change2'
      if el.is '[name=comm_percent]'
        @countedCommission 'price'
      else if el.is '[name=comm_price]'
        @countedCommission 'precent'


    @found.form_price.on 'change', 'input[type=text]', (e) =>
      console.log 'change1'
      for el in @found.form_price.find('input[type=text]').toArray()

        unless el.value
          @found.full_price.text('0 руб.')
          return false

      v = @getPrices()

      if v.spread_price
        @found.full_price.text("#{v.spread_price.join('-')} руб.")
        @income = v.spread_price
        @countedCommission 'precent'

    new History @found.list_history

    @income = @found.full_price.text().split(/\s*-\s*/).map (v)-> parseFloat(v)

  countedCommission : (field) =>

    if @income
      medium = 0
      medium += p for p in @income
      medium /= @income.length
      elem = @found.commision.find('[name=comm_percent],[name=comm_price]')

      switch field
        when 'price'
          v = elem.filter('[name=comm_percent]').val()*medium/100
          elem.filter('[name=comm_price]').val(Math.floor(v/10)*10)
        when 'precent'
          v = elem.filter('[name=comm_price]').val()*100/medium
          elem.filter('[name=comm_percent]').val(Math.floor(v*10)/10)

  onShowDetail : (e) =>
    a = $(e.currentTarget)
    index = a.attr('data-index')
    tutor = @tree.value.link_detail[index]

    if tutor?
      @dom.find("a.show").css {opacity: ''}
      a.css {opacity: 0.8}
      @found.about_tutor.show().attr('data-index', index)
      @found.avatar.attr('src', tutor.photos[0].hurl)
      @found.name.text("#{tutor.name.first} #{tutor.name.middle} #{tutor.name.last}")
      Q.spawn =>
        link = '/tutor_profile?'+yield Feel.udata.d2u('tutorProfile',{index})
        @found.to_profile.attr('href', link)

    return false

  onMakeExecutor : (e) =>
    index = $(e.currentTarget).closest('.about_tutor').attr('data-index')
    @found.index_tutor.executor.val(index)
    @dom.find("a.show[data-index]").each ->

      if $(this).is "[data-index=\"#{index}\"]"
        $(this).addClass('selected')
      else
        $(this).removeClass('selected')

    return false

  onSaveChange : =>
    data = @getValue()
    console.log data
    console.log yield Feel.jobs.server 'changeBid', data
    return false

  _getChecked : (from, to) =>

    if typeof(to) is 'object'
      from = from.find('input[type="checkbox"]')

      if to instanceof Array
        from.each ->
          to.push this.value if $(this).is ':checked'
          return true
      else
        from.each ->
          to[this.value] = $(this).is ':checked'
          return true


  getGender : => @found.gender.find('input[type="radio"]:checked').val()

  calcPrices : (final_price) =>
    res = [1, 1]
    for key in ['lesson_price', 'lesson_count', 'count_week']
      return null unless a = final_price[key]

      if a.length  > 1
        res[0] *= a[0]
        res[1] *= a[1]
      else if a.length == 1
        res[0] *= a[0]
        res[1] *= a[0]
      else
        return null

    res.pop() if res[0] == res[1]
    k = (1 + final_price['chance_add']/100)*(1 - final_price['chance_fail']/100)*(1 - final_price['chance_cancel']/100)
#    console.log k
    return null unless k
    return res.map (v) -> Math.round(v*k)

  getPrices : =>
    result = {}
    @found.form_price
    .add(@found.commision)
    .find('input[type=text][name], input[type=hidden][name]')
    .each ->
      a = $(this)
      result[a.attr('name')] = a.val()
    regexp = /\s*\-\s*/
    for name in ['lesson_price', 'lesson_count', 'count_week', 'chance_fail', 'chance_cancel', 'chance_add', 'comm_percent', 'comm_price']

      if val = result[name]

        switch name
          when 'lesson_price', 'lesson_count', 'count_week'
            val = val.split(regexp).map((v) -> parseFloat(v || 0)).sort((a, b)-> a - b )
          else
            val = parseFloat(val || 0)
        result[name] = val

    result["spread_price"] = @calcPrices(result)
    return result

  setValue : (value) =>
    console.log @income = value.final_price.spread_price

  getValue : =>
    result = {
      gender : @getGender()
      status : {}
      moderate : @found.moderate.prop('checked')
      comment : @found.comment.val()
      subjects : @sub.getValue()
      final_price : @getPrices()
    }

    @_getChecked @found.status, result.status
    @found.form_person.find('input[type=text][name], input[type=hidden][name], select[name]').each ->
      a = $(this)
      result[a.attr('name')] = a.val()

    return result