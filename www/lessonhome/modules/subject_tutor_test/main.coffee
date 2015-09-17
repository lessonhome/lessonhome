class @main
  Dom: =>
    @btn_expand = @found.expand
    @btn_remove = @found.remove
    @container = @found.container
  show : =>
    @btn_expand.click =>
      if @container.is ':visible'
        @container.slideUp 300
      else
        @container.slideDown 300
#    @classes = [
#      @tree.place_tutor.class,
#      @tree.place_pupil.class,
#      @tree.place_remote.class,
#      @tree.group_learning.class
#    ]
##    setInterval @updateAll, 100
#    @initAll()
#  initAll : =>
#    $.each @classes, (i, el) =>
#      el.block.hide()
#      el.checkbox.dom.click ->
#        if el.checkbox.getValue()
#          el.block.slideUp 200
#        else
#          el.block.slideDown 200
#      el.initAll?()
#  updateAll : =>
#    $.each @classes, (i, cl) => cl.updateAll?()
