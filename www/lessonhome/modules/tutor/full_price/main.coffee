class @main
  Dom : =>
    @checkbox = @tree.place.class
    @block = @found.hour_block
    @children = [
      @tree.one_hour.class,
      @tree.two_hour.class,
      @tree.three_hour.class
    ]
  initAll : =>
    $.each @children, (i, el) => el.init() if el.init?
  updateAll : =>
    $.each @children, (i, el) => el.update() if el.update?



