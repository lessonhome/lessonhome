


class @main extends EE
  Dom : =>
    @tree.default ?= false
    @tree.value ?= @tree.state if @tree.state?
    @label = @dom.find "label"
    @check_box = @found.check_box
    @check = @found.check
  show : =>
    @state = @tree.value
    @setValue @state
    @dom.on 'click', => @setValue !@getValue()
    #  @label.toggleClass('active')
    #  @state = @label.hasClass 'active'
    #  @emit 'change',@state
    #  @emit 'end'


  getValue : => @state = @label.hasClass 'active'

  setValue : (val)=>
    val ?= @tree.default
    if val
      @label.addClass 'active'
      @state = @label.hasClass 'active'
    else
      @label.removeClass 'active'
      @state = @label.hasClass 'active'
    @emit 'change',val
    @emit 'end',val
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

  changeValue: =>
    if @state
      @setValue false
    else
      @setValue true

  # event:  end, focus, blur, change





