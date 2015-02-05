class @main extends EE
  show : =>
    @drop_down_box = @dom.find '.drop_down_box'
    @dom.on 'click', => @change_visibility @drop_down_box

    @current = @dom.find ".current"
    @items = @dom.find ".item"
    drop_down_box_indent = 0
    for item in @items
      item = $(item)
      do(item, drop_down_box_indent)=>
        item.on 'click', =>
          @current.html(item.html())
          drop_down_box.css("top", "#{drop_down_box_indent}px")
      drop_down_box_indent -= 29
  change_visibility: (element)=>
    if element.css("display") == 'none'
      element.css("display", "block")
    else
      element.css("display", "none")
