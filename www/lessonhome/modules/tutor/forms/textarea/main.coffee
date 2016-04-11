class @main extends EE
  Dom : =>
    @label = @dom.find('>label')
    @input = @found.input
    @val    = @found.input.val()
  show : =>
    @input.on 'input',=> @emit 'change'
    @input.on 'focus', => @label.addClass 'focus'
    @input.on 'focusout', =>
      @label.removeClass 'focus'
      @emit 'change'
      @emit 'end'

  getValue : => @input.val()
  setValue : (text)=> @input.val text || ''
  


