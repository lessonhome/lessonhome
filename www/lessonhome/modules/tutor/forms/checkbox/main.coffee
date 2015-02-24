class @main extends EE
  show : =>
    @check = @dom.find(".check")
    @check = @dom.find ".check"
    @dom.on 'click', => @check.toggleClass 'active'

