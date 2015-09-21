class @main
  Dom : =>
    @children = {
      price : @tree.price.class
      groups : @tree.group_people.class
    }
  getValue : =>
    result = {}
    $.each @children, (key, cl) => result[key]?= cl.getValue?()
    return result
  setValue : (data) =>
    if data isnt undefined
      $.each @children, (key, cl) =>
        if data[key] isnt undefined then cl.setValue? data[key]
