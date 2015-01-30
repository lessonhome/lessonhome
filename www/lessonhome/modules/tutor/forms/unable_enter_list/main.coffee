class @main extends EE
  show : =>
    @drop_down_box = @dom.find '.drop_down_box'
    @dom.on 'click', => @change_visibility @drop_down_box

    @current = @dom.find ".current"
    @items = @dom.find ".item"
    for item in @items
      item = $(item)
      do(item)=>
        item.on 'click', => @current.html(item.html())
        
  change_visibility: (element)=>
    if element.css("display") == 'none'
      element.css("display", "block")
    else
      element.css("display", "none")
