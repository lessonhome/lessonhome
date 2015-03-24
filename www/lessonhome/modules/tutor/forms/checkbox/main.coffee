class @main extends EE
  Dom : =>
    @label = @dom.find "label"
    @check_box = @label.children '.check_box'
    @check = @check_box.children ".check"

  show : =>

    @dom.on 'click', =>
      @label.toggleClass 'active'


