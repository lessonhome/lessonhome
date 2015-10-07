class @main
  Dom : =>
    @trigger = @tree.trigger
    @trigger = @dom.parent() if typeof(@trigger) is 'string'
    @trigger = @trigger.class if @trigger._isModule
  show: =>
    if @trigger.__isClass
      @trigger.on 'submit', @callback
    else
      @trigger.on 'click', @callback
  callback : =>
    Feel.bid_attached.showForm()
    return false