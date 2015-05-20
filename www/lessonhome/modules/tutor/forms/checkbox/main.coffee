


class @main extends EE
  Dom : =>
    @tree.value ?= @tree.state if @tree.state?
    @label = @dom.find "label"
    @check_box = @found.check_box
    @check = @found.check
  show : =>
    @state = @tree.value
    console.log 'state is'+@state
    @setValue @state
    @dom.on 'click', =>
      @label.toggleClass('active')
      @state = @label.hasClass 'active'
      @emit 'change',@state
      @emit 'end'




  getValue : => @state = @label.hasClass 'active'

  setValue : (val)=>
    if val
      @label.addClass 'active'
      @state = @label.hasClass 'active'
    else
      @label.removeClass 'active'
      @state = @label.hasClass 'active'

  showError : (error)=>
    if @errorDiv?
      @errorDiv.text error
      @errorDiv.show()
  hideError : =>
    if @errorDiv?
      @errorDiv.hide()
      @errorDiv.text ""
  setErrorDiv : (div)=>
    @errorDiv = $ div

  # event:  end, focus, blur, change





