class @main extends EE
  show : =>
    @min = @tree.min
    #if !@min? then @min = 0
    @max = @tree.max
    unless @max? && @min?
      e = new Error "not defined variable min/max in main/slader_main"
      console.error e,@tree
      throw e
    foo()
    @start = @tree.start?.class
    @end   = @tree.end?.class
    @slider = @tree.move.class
    @end?.addReplace? /\D/,""
    @start?.addReplace? /\D/,""
    @start?.setValue @min
    @end?.setValue @max

    setSliderPos = (sliderCorn, inputVal) =>
      sliderCorn.set (inputVal-@min) / (@max-@min)

    setInputVal = (inputCmp, x) =>
      inputCmp.setValue (Math.round (@max-@min)*x + @min)

    @start?.on 'end', =>
      slider = @slider.left if @slider.left?
      slider ?= @slider.right if @slider.right?
      setSliderPos(slider, +@start.getValue()) if slider?

    @end?.on 'end', =>
      slider = @slider.right if @slider.right?
      slider ?= @slider.left if @slider.left?
      setSliderPos(slider, +@end.getValue()) if slider

    @slider.on 'left_slider_move', (x) =>
      input = @start if @start?
      input ?= @end  if @end?
      setInputVal input, x
      #input.setValue (Math.round (@max-@min)*x + @min)

    @slider.on 'right_slider_move', (x) =>
      input = @end  if @end?
      input ?= @start if @start?
      setInputVal input, x




