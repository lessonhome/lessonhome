class @main
  Dom : =>
    @children =
      one_hour : @tree.one_hour.class
      two_hour : @tree.two_hour.class
      tree_hour : @tree.three_hour.class
  show : =>
    timer = setInterval(
      =>
        try
          @updateAll()
        catch error
          clearInterval timer
          throw error
    , 100)
  updateAll : =>
    $.each @children, (key, cl) =>
      cl.update()
  getValue : =>
    result = {}
    $.each @children, (key, cl) -> result[key] = cl.getValue?()
    return result
  setValue : (data) =>
    if data isnt undefined
      $.each @children, (key, cl) =>
        if data[key] isnt undefined then cl.setValue? data[key]

