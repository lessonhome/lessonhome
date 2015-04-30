class @main extends EE
  Dom : =>
    @label = @dom.find "label"
    @textarea = @label.children 'textarea'
    @textarea_tag = @textarea[0]
    @val    = $(@textarea_tag).val()
  show : =>
    @textarea.on 'focus', => @label.addClass 'focus'
    @textarea.on 'focusout', => @label.removeClass 'focus'

  getValue : =>
    return $(@textarea[0]).val()


