class @main
  Dom : =>
    @panel_form = @found.form
    @panel_complate = @found.complate

    @btn = @tree.btn_send.class
    @name = @tree.field_name.class
    @phone = @tree.field_phone.class
  show : =>
    @attach = Feel.bid_attached
    @phone.on 'end', @sendForm
    @btn.on 'submit', @sendForm
  sendForm: => Q.spawn =>
    errors = yield @attach.sendForm()
    @showComplete()

  showComplete: =>
    @dom.css height: @dom.height()
    @panel_form.fadeOut 200, =>
      @dom.animate {height :@panel_complate.height()}, 200, =>
        @panel_complate.fadeIn 200
#        @dom.css {height: 'auto'}
