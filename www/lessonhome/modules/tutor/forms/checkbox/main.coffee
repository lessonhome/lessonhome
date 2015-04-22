class @main extends EE
  Dom : =>
    @label = @dom.find "label"
    @check_box = @found.check_box
    @check = @found.check

  show : =>
    @state = @tree.state  
    @dom.on 'click', =>
      @label.toggleClass('active')
      @state = @label.hasClass 'active'
      @emit 'change',@state

  getValue : =>
    @label.hasClass 'active'

  setValue : (val)=>
    @label.hasClass = val

  # showError() and hideError() = no

  # event:  end, focus, blur, change





