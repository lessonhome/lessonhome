class @main extends EE
  Dom : =>
    @start  = @tree.start?.class
    @end    = @tree.end?.class
    @slider = @tree.move.class
    @move   = @tree.move.class
    if @tree.min? || @tree.max?
      throw new Error 'use new syntax tree.value.{min|max} insted tree.{min|max}'
    unless @tree.value?
      console.log @
      throw new Error 'need value in tree(new style of slider/main_slider)'
    @tree.value.left  ?=  @tree.value.min
    @tree.value.right ?=  @tree.value.max
    @min ?= @tree.value?.min
    @max ?= @tree.value?.max

  show : =>

    #@start?.setValue @tree.value.left
    #@end?.setValue @tree.value.right

    if @move.getType() != 'default'
      $(@found.start).hide()

    #


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
      @emit 'change'
      @emit 'end'

    @slider.on 'right_slider_move', (x) =>
      input = @end  if @end?
      input ?= @start if @start?
      setInputVal input, x
      @emit 'change'
      @emit 'end'

    @setValue @tree.value
    unless @max? && @min?
      e = new Error "not defined variable min/max in main/slader_main"
      console.error e,@tree
      throw e
    @end?.addReplace? /\D/,""
    @start?.addReplace? /\D/,""

    #
    @setDivision()

  setValue : (v={})=>
    v.max ?= @max
    v.min ?= @min
    throw new Error 'bad value' unless v.min? && v.max? && v.left? && v.right?
    @min = v.min
    @max = v.max

    @start?.setValue? v.left
    @end?.setValue? v.right
    @end?.emit? 'end'
    @start?.emit? 'end'
  recheck : =>
    @end?.emit? 'end'
    @start?.emit? 'end'

  getValue : =>
    return {
      left  : @start?.getValue?()
      right : @end?.getValue?()
      min   : @min
      max   : @max
    }

  setDivision : =>
    @division_value = @tree.division_value
    number = (@max - @min)/@division_value
    delta  = (@division_value/(@max - @min)) * 100
    i = 1
    while i <= number
      @move.setLine delta*i++

  reset : =>
    @start?.setValue? @min
    @end?.setValue? @max
    @end?.emit? 'end'
    @start?.emit? 'end'
