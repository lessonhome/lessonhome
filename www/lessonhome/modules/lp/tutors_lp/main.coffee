class @main
  constructor : ->
    $W @
  Dom : =>
    @sliderBlock    = @found.slider_block
    @sliderLeft     = @found.slider_left
    @sliderRight    = @found.slider_right
    @sliderArea     = @found.slider_area
    @sliderOpacity  = @found.slider_opacity
  show: =>
    $(@sliderBlock).slider(
      {
        height: 565
      }
    )
    $(@sliderRight).on 'click', =>
      $(@sliderBlock).slider('next')
    $(@sliderLeft).on 'click', =>
      $(@sliderBlock).slider('prev')
    $(@sliderRight).hover(
      => $(@sliderBlock).slider('pause')
      => $(@sliderBlock).slider('start')
    )
    $(@sliderLeft).hover(
      => $(@sliderBlock).slider('pause')
      => $(@sliderBlock).slider('start')
    )
    $(@sliderArea).hover(
      => $(@sliderBlock).slider('pause')
      => $(@sliderBlock).slider('start')
    )
    $(@sliderOpacity).hover(
      => $(@sliderBlock).slider('pause')
      => $(@sliderBlock).slider('start')
    )