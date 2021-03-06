class @main
  constructor : ->
    $W @

  Dom : =>
    @test = @tree.test.class

  show : =>
    items = yield @$send './save','quiet'
    for item,i in items
      continue if i == 0
      @test.add(item).show()

    @test.on 'preremove', (elem) =>
      univ = elem.title.getValue()
      elem.text_restore.text 'Удалить образование ' + univ + '?'

    $('html').on 'click', => @test.eachElem -> @onRestore()

  interpretError : (errors = {}) =>
    result = {}
    #    return result if errors.correct is true
    if errors['name'] is 'empty_field' then result['name'] = 'Введите название вуза'
    if errors['faculty'] is 'empty_field' then result['faculty'] = 'Введите название факультета'
    if errors['period']? then result['period'] = 'Введите корректные даты'

#    switch 'not_string'
#      when errors['country'], errors['city'], errors['chair'], errors['qualification'], errors['comment'], errors['period']
#        result['other'] = 'Некорректные типы данных'

    return result

  showErrors : (errors) =>
    Feel.sendAction 'error_on_page' unless errors.correct
    that = @
    @test.eachElem (i) ->
      if errors[i]? then @slideDown() else @slideUp()
      if not errors[i]? then @slideUp()
      @showErrors that.interpretError(errors[i])

  save : (data)=>
    items = []
    @test.eachElem ->
      val = @getValue()
      items.push(val) if @form.fill or val.name isnt ''
    errors = @js.check items
    if errors.correct is true
      data = yield @$send './save', items
      if data.status is 'success'
        return true
      else if data.status is 'failed'
        @showErrors data.errs
    else
      @showErrors errors
    return false

