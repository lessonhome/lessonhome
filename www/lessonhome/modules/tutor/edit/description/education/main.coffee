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

  getValue : =>
    result = {}
    @test.eachElem (i) -> result[i] = @getValue()
    return result

  save : (data)=>
    items = []
    @test.eachElem -> items.push @getValue()
    yield @$send './save', items

