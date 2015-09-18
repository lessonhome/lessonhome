class @main
  Dom: =>
    @classes = [
      @tree.one_hour.class,
      @tree.two_hour.class,
      @tree.three_hour.class,
    ]
  show : =>
    timer = setInterval(
      =>
        try
          @updateAll()
        catch error
          clearInterval(timer)
          throw error
    , 100)
  updateAll : =>
    $.each @classes, (i, cl) =>
      cl.update()

