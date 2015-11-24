class @main
  Dom : =>
    @title = @found.title
    @template = @found.template
    @table = @found.table
    @table_title = @found.table_title
    @table_plus = @found.table_plus
    @titles = [
      ['tutor', "У репетитора"],
      ['pupil',  "У Ученика"],
      ['remote' , "Skype"]
    ]
    @main = null
  fillTable : (table, val = {}) =>
    tbody = table.find('tbody').html('')
    tbody.append("<tr><td>60 мин.</td><td>#{val['v60']} руб.</td></tr>") if val['v60']?
    tbody.append("<tr><td>90 мин.</td><td>#{val['v90']} руб.</td></tr>") if val['v90']?
    tbody.append("<tr><td>120 мин.</td><td>#{val['v120']} руб.</td></tr>") if val['v120']?

  addPrices : (title, val) =>
    @table_title.text title

    if @main? and (diff = @getDiff(@main, val))? then val = diff

    if typeof val == 'string'
      @table.hide()
      @table_plus.text val + ' руб.'
    else if typeof val == 'object'
      @fillTable @table, val
      @table.show()
      @table_plus.text ''
    @dom.append @template.clone().children()

  setValue : (value) =>
    for title, i in @titles
      if (price = value[ title[0] ])?
        @addPrices title[1], price
        @main = price unless @main?


  getDiff : (p1, p2) ->
    min_diff = null
    max_diff = null
    for key in ['v60', 'v90', 'v120']
      return if p1[key]? != p2[key]?
      continue unless p1[key]?
      diff = p2[key] - p1[key]
      min_diff = diff if  not min_diff? or min_diff > diff
      max_diff = diff if not max_diff? or max_diff < diff
    return if max_diff - min_diff > 50
    result = (max_diff + min_diff)/2
    result /= 50
    result = Math.round result
    result *= 50
    if result > 0 then result = '+' + result
    return ''+result

  setTitle : (val) => @title.text val
