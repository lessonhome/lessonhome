class @main
  Dom: =>
    @content = @found.content
    @trigger = @tree.trigger.class
  show:=>
    @trigger.dom.on 'click', (e) =>
      if @trigger.getValue()
        @slideUp()
      else
        @slideDown()
  slideUp : =>
    @content.stop().animate {opacity: 0}, 200, =>
      @content.slideUp 200
  slideDown : =>
    @content.stop().slideDown 200, =>
      @content.animate {opacity: 1}, 200
  openContent : =>
    @trigger.setValue true
    @content.show().css 'opacity', 1
  closeContent : =>
    @trigger.setValue false
    @content.hide().css 'opacity', 0
  setValue : (data) =>
    if data.selected is true then @openContent()
    @tree.content.class.setValue data
  getValue : =>
    data = @tree.content.class.getValue()
    data['selected'] = @trigger.getValue()
    return data