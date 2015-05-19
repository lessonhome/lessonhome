
class @main
  Dom : =>
    @icon_box = @found.icon_box

  changeIcon : =>
    @icon_box.toggleClass("closed")