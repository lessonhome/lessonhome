
class @main
  show : =>
    @bNext = @tree.button_next.class
    @form = @tree.content.form.class

    @bNext.on 'submit', @next

  next : =>
    @form?.save?().then (success)=>
      if success
        @bNext.submit()
    .done()