class @main
  constructor : ->
    $W @
  show : =>
    @items = []
    @clone = @tree.item.class
    @items.push @tree.item.class
    @found.add_button.click => @add()
    items = yield @$send './save','quiet'
    for item,i in items
      continue if i == 0
      @add item
  add : (data={})=>
    cl = @clone.$clone()
    dom = $('<div class="item"></div>')
    dom.append cl.dom
    data.learn_from = data?.period?.start || ""
    data.learn_till = data?.period?.end || ""
    delete data.period
    cl.setValue data
    @found.items.append dom
    @items.push cl
  save : (data)=>
    items = []
    for item in @items
      continue if item.removed
      obj = item.getValue()
      str = ""
      for key,val of obj
        str += val
      unless str.length > 10
        item.remove()
        continue
      obj.period =
        start : obj.learn_from
        end   : obj.learn_till
      delete obj.learn_from
      delete obj.learn_till
      items.push obj
    yield @$send './save',items

