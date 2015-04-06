class @main extends EE
  Dom : =>
    @label = @dom.find "label"
    @textarea = @label.children 'textarea'
    @val    = @textarea.val()
  show : =>
    @textarea.on 'focus', => @label.addClass 'focus'
    @textarea.on 'focusout', => @label.removeClass 'focus'

  getValue : =>
    return @val