class @main extends EE
  Dom : =>
    @division_value = @tree.division_value
    if @tree.type == 'right'
      delete @tree.start
    @start  = @tree.start?.class
    @end    = @tree.end?.class
    @slider = @tree.move.class
    @move   = @tree.move.class
    if @tree.min? || @tree.max?
      throw new Error 'use new syntax tree.value.{min|max} insted tree.{min|max}'
    unless @tree.value?
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

    setSliderPos = (sliderCorn, inputVal) =>
      if @tree.division_value>0
        inputVal = Math.round(inputVal/@tree.division_value)*@tree.division_value
      sliderCorn.set (inputVal-@min) / (@max-@min)

    setInputVal = (inputCmp, x) =>
      inputVal = (Math.round (@max-@min)*x + @min)
      if @tree.division_value>0
        inputVal = Math.round(inputVal/@tree.division_value)*@tree.division_value
      inputCmp.setValue inputVal

    @start?.on 'end', =>
      slider = @slider.left if @slider.left?
      slider ?= @slider.right if @slider.right?
      setSliderPos(slider, +@start.getValue()) if slider?

    @end?.on 'end', =>
      slider = @slider.right if @slider.right?
      slider ?= @slider.left if @slider.left?
      setSliderPos(slider, +@end.getValue()) if slider?

    @slider.on 'left_slider_move', (x)=>
      input = @start if @start?
      input ?= @end  if @end?
      setInputVal input,x # @parseVal(left:x).left
      #slider = @slider.left ? @slider.right
      #setSliderPos(slider,+input?.getValue()) if slider?
      #input.setValue (Math.round (@max-@min)*x + @min)
      @emit 'change'
      @emit 'end'

    @slider.on 'right_slider_move', (x)=>
      input = @end  if @end?
      input ?= @start if @start?
      setInputVal input, x #@parseVal(right:x).right
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
    #@start?.setValue @tree.value.left
    #@end?.setValue @tree.value.right

  setValue : (v={})=>
    @tree.value[key]=val for key,val of v
    v = @tree.value
    v.max ?= @max
    v.min ?= @min
    v.left ?= @tree?.default?.left
    v.right ?= @tree?.default?.right
    #throw new Error 'bad value' unless v.min? && v.max? && v.left? && v.right?
    @min = v.min
    @max = v.max
    unless v.left >= 0
      v.left = @tree?.default?.left ? @min
    unless v.right >= 0
      v.right = @tree?.default?.right ? @max
    @start?.setValue? v.left
    @end?.setValue? v.right
    @end?.emit? 'end'
    @start?.emit? 'end'
    @emit 'change'
  recheck : =>
    @end?.emit? 'end'
    @start?.emit? 'end'
  parseVal : ({left,right})=>
    if left?
      left = +left
      unless left>=0
        left = @tree.value.min
      if @tree.division_value>0
        left = Math.round(left/@tree.division_value)*@tree.division_value
    if right?
      right = +right
      unless right>=0
        right = @tree.value.max
      if @tree.division_value>0
        right= Math.round(right/@tree.division_value)*@tree.division_value
    return {left,right}

      

  getValue : =>
    s = @start?.getValue?()
    @tree.value.left = s if s > 0 || s == 0
    e = @end?.getValue?()
    @tree.value.right = e if e > 0 || e == 0
    return @tree.value
    #{
    #    : @start?.getValue?()
    #    right : @end?.getValue?()
    #}

  setDivision : =>
    number = (@max - @min)/@division_value
    dv = @division_value
    while (number>30)
      dv+= @division_value
      number = (@max-@min)/dv
    return if number < 3
    delta  = 100/number
    i = 1
    while i <= number
      @move.setLine delta*i++

  reset : => @setValue()
