class @main
  constructor : ->
    $W @
  Dom : =>
    @sliderBlock    = @found.slider_block
    @sliderLeft     = @found.slider_left
    @sliderRight    = @found.slider_right
    @sliderArea     = @found.slider_area
    @sliderOpacity  = @found.slider_opacity
    @sliderElements = [@sliderLeft, @sliderRight, @sliderArea, @sliderOpacity]
  show: =>
    @sliderBlock.slider height: 565
    @sliderRight.on 'click', =>
      @sliderBlock.slider('next')
    @sliderLeft.on 'click', =>
      @sliderBlock.slider('prev')

    for el in @sliderElements
      el.hover(
        => @sliderBlock.slider('pause')
        => @sliderBlock.slider('start')
      )
    @sliderBlock.css('height', 'auto')
