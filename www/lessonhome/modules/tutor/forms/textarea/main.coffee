class @main extends EE
  Dom : =>
    @label = @dom.find "label"
    @textarea = @label.children 'textarea'
    @textarea_tag = @textarea[0]
    @val    = $(@textarea_tag).val()
  show : =>
    @textarea.on 'input',=> @emit 'change'
    @textarea.on 'focus', => @label.addClass 'focus'
    @textarea.on 'focusout', =>
      @label.removeClass 'focus'
      @emit 'change'
      @emit 'end'

  getValue : =>
    return $(@textarea[0]).val()
  setValue : (text)=>
    text = '' unless text
    @tree.value = text
    $(@textarea[0]).val text
  


