
class @main
  show : =>
    @button_next = @tree.button_next?.class
    @content = @tree.content.class
    @button_next?.on 'submit', @b_next

  b_next : =>
    @content?.save?().then (success)=>
      @button_next.submit() if success
      return true
    .done()

