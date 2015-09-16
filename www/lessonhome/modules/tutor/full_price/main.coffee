class @main
  Dom : =>
    @checkbox = @tree.place.class
    @block = @found.hour_block
    @classes = [
      @tree.one_hour.class,
      @tree.two_hour.class,
      @tree.three_hour.class
    ]
  initAll : =>
    $.each @classes, (i, el) => el.init() if el.init?
  updateAll : =>
    $.each @classes, (i, el) => el.update() if el.update?



