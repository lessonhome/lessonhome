class @main
  Dom : =>
    @title = @found.title
    @template = @found.template
    @table = @found.table
    @main_table = @found.main_table
    @table_title = @found.table_title
    @table_plus = @found.table_plus
#  show : =>
#    @fillTable @main_table, {v60: 1111, v120: 1222}
#    @addTable 'Заказ тилибрии', {v90: 2000}
#    @addTable 'По скайпу', '+3000'
#    @addTable 'Зарост на машенке', {v60: 1111, v120: 1222}

  fillTable : (table, val = {}) =>
    tbody = table.find('tbody').html('')
    tbody.append("<tr><td>60 мин.</td><td>#{val['v60']} руб.</td></tr>") if val['v60']?
    tbody.append("<tr><td>90 мин.</td><td>#{val['v90']} руб.</td></tr>") if val['v90']?
    tbody.append("<tr><td>120 мин.</td><td>#{val['v120']} руб.</td></tr>") if val['v120']?

  addTable : (title, val) =>
    @table_title.text title
    if typeof val == 'string'
      @table.hide()
      @table_plus.text val
    else if typeof val == 'object'
      @table.show()
      @table_plus.text ''
      @fillTable @table, val
    @dom.append @template.clone().children()

  setValue : (title, value) =>
    @title.text title

      
