class @main extends EE
  show : =>
    @min = @tree.min
    if !@min? then @min = 0
    @max = @tree.max

    @start = @tree.start?.class
    @end   = @tree.end?.class
    @slider = @tree.move.class

    @start?.setValue @min
    @end?.setValue @max

    setSliderPos = (sliderCorn, inputVal) =>
      sliderCorn.set (inputVal-@min) / (@max-@min)

    setInputVal = (inputCmp, x) =>
      inputCmp.setValue (Math.round (@max-@min)*x + @min)

    @start?.on 'change', =>
      setSliderPos(@slider.left, +@start.getValue())

    @end?.on 'change', =>
      setSliderPos(@slider.right, +@end.getValue())

    @slider.on 'left_slider_move', (x) =>
      setInputVal @start, x
      @start.setValue (Math.round (@max-@min)*x + @min)

    @slider.on 'right_slider_move', (x) =>
      setInputVal @end, x




