class @main
  Dom : =>
    @panel_form = @found.form
    @panel_complate = @found.complate

    @btn = @tree.btn_send.class
    @name = @tree.field_name.class
    @phone = @tree.field_phone.class
  show : =>
    @attach = Feel.bid_attached
    @phone.on 'end', => console.log 'end'

    @btn.on 'submit', => console.log 'submit'

#    errors = yield @attach.sendForm()
#    if errors['phone']?
#      @phone.showError()
#      return false
#    else
#      return true

  sendForm : =>
    error = yield @attach.sendForm()
  showComplete: =>
    @dom.css height: @dom.outerHeight()
    @panel_form.fadeOut 200, =>
#      @dom.animate {height :@panel_complate.outerHeight(true)}, 200, =>
#        @panel_complate.fadeIn 100, =>
#          @dom.css {height: 'auto'}
      @panel_complate.fadeIn 100