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
  setValue : (data = {price : '0'}) =>
    $.each @children, (key, cl) =>
      cl.setValue? data[key]
