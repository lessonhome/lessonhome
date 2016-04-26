

class @main
  constructor : ->
    $W @
  Dom : =>
    @tree.value ?= {}
  show : =>
    @dom.click @checkActive

  checkActive : => Q.spawn =>
    return if @tree.value.active
    o = $(window).scrollTop()
    @parent?.activeBid?.deactivate?()
    @activate()
    $(window).scrollTop o
  deactivate : =>
    return unless @tree.value.active
    @tree.value.active = false
    @found.bid.attr 'active',''
  activate : =>
    return if @tree.value.active
    @parent?.activeBid = @
    @tree.value.active = true
    @found.bid.attr 'active','active'
    @tree.chat.class.reinit()
    
  


