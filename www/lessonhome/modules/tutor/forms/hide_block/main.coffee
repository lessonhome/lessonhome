class @main
  Dom: =>
    @content = @found.content
    @trigger = @tree.trigger.class
  show:=>
    @trigger.dom.on 'click', =>

      if @trigger.getValue()
        @hideContent()
      else
        @showContent()
  hideContent : =>
    @content.animate {opacity: 0}, 200, =>
      @content.slideUp 200
  showContent : =>
    @content.slideDown 200, =>
      @content.animate {opacity: 1}, 200
