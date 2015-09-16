class @main
  show : =>
    @classes = [
      @tree.place_tutor.class,
      @tree.place_pupil.class,
      @tree.place_remote.class,
      @tree.group_learning.class
    ]
    setInterval @updateAll, 100
    @initAll()
  initAll : =>
    $.each @classes, (i, el) =>
      el.block.hide()
      el.checkbox.dom.click ->
        if el.checkbox.getValue()
          el.block.slideUp 200
        else
          el.block.slideDown 200
      el.initAll?()
  updateAll : =>
    $.each @classes, (i, cl) => cl.updateAll?()
