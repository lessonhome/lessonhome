class @main
  Dom : =>
    @checkbox = @tree.hour.class
    @field = @tree.cost.class
  show : =>
    @checkbox.label.click @onCheck
  isEmpty : =>
    @field.getValue() is ''
  update : =>
    if @isEmpty()
      @checkbox.setValue false
    else
      @checkbox.setValue true
  onCheck : (e) =>
    if @checkbox.getValue()
      if !@isEmpty()
        @field.saveValue()
      @field.setValue ''
    else
      if (value = @field.getSaved()) isnt undefined
        @field.setValue value
      else
        e.stopPropagation()
      @field.focus()

