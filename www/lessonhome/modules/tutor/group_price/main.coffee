class @main
  Dom : =>
    @classes = {
      price : @tree.price.class.class
      groups : @tree.group_people.class
    }
  getValue : =>
    result = {}
    $.each @classes, (key, cl) => result[key]?= cl.getValue?()
    return result
  setValue : (data) =>
    if data isnt undefined
      $.each @classes, (key, cl) =>
        if data[key] isnt undefined then cl.setValue? data[key]
