class @main
  TITLES = [
    ['tutor', "У репетитора"],
    ['pupil',  "Выезд"],
    ['remote' , "Skype"]
  ]

  TIMES = [
    ['v60', 60],
    ['v90', 90],
    ['v120', 120]
  ]

  Dom : =>

    @title = @found.title
    @container =  @found.price_list_table.html('')
    @template = @found.template
    @table = @found.table
    @table_title = @found.table_title
    @table_plus = @found.table_plus

  fillTable : (table, val = {}) =>
    tbody = table.find('tbody').html('')
    tbody.append("<tr><td>60 мин.</td><td>#{val['v60']} руб.</td></tr>") if val['v60']?
    tbody.append("<tr><td>90 мин.</td><td>#{val['v90']} руб.</td></tr>") if val['v90']?
    tbody.append("<tr><td>120 мин.</td><td>#{val['v120']} руб.</td></tr>") if val['v120']?

  addPrices : (val, title) =>

    if title
      @table_title.text(title)
      @table_title.parent().show()
    else
      @table_title.parent().hide()

    if typeof val == 'string'
      @table.hide()
      @table_plus.text val
    else if typeof val == 'object'
      @fillTable @table, val
      @table.show()
      @table_plus.text ''

    @container.append @template.clone().children()

  initDom : (value, short = false) =>

    @container.html ''

    main = null
    for title in TITLES

      if (price = value[ title[0] ])?

        if title[0] == 'remote'
          value = if short then ''  + @getPriceAtHour(price) + ' руб. в час' else price
          @addPrices value, title[1]
          continue

        if main

          if (diff = @getDiff main, price)?

            if diff > 0
              @addPrices diff + ' руб.', title[1]
            else
              unless short
                @addPrices price, title[1]

          else
            @addPrices price, title[1]

        else
          main = price
          @addPrices main, (unless short then title[1] else '')
    return @dom.clone().children()


  getPriceAtHour : (time_prices) =>
    result = 0
    count = 0
    for key in TIMES when time_prices[key[0]]?
      result += time_prices[key[0]]/key[1]
      count++
    return if count == 0
    result *= 60/count

    result /= 50
    result = Math.round result
    result *= 50
    return result

  getGeneral : (priceArr) =>
    result = {}

    for place in TITLES
      for time in TIMES
        for prices in priceArr when prices[place[0]]?[time[0]]?
          result[place[0]] = {} unless result[place[0]]?
          result[place[0]][time[0]] = prices[place[0]][time[0]]
          break

    return result

  getDiff : (p1, p2) ->
    min_diff = null
    max_diff = null
    for key in TIMES
      return if p1[key[0]]? != p2[key[0]]?
      continue unless p1[key[0]]?
      diff = p2[key[0]] - p1[key[0]]
      min_diff = diff if  not min_diff? or min_diff > diff
      max_diff = diff if not max_diff? or max_diff < diff
    return if max_diff - min_diff > 50
    result = (max_diff + min_diff)/2
    result /= 50
    result = Math.round result
    result *= 50
    result = '+' + result if result > 0
    return result


  getShort : (priceArr) =>
    @title.hide()
    return @initDom @getGeneral(priceArr), true

  getOne : (price, title) =>
    @title.show().text title
    return @initDom price
