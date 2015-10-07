class @main
  constructor: ->
    Wrap @
  Dom : =>
    @panel_form = @found.form
    @panel_complate = @found.complate
    @panel_wrap = @found.wrap
    @phone = @tree.field_phone.class
  show : =>
    @attach = Feel.bid_attached
    @phone.on 'end', @sendForm.out

    @tree.btn_send.class.on 'submit', => Q.spawn =>
      correct = yield @sendForm()
      if correct then @showComplete()

  sendForm : =>
    error = yield @attach.sendForm()
    if error['phone']?
      @tree.field_phone.class.showError()
      return false
    else
      return true
  showComplete: =>
    @panel_wrap.css height: @panel_wrap.outerHeight()
    @panel_form.fadeOut 200, =>
#      @dom.animate {height :@panel_complate.outerHeight(true)}, 200, =>
#        @panel_complate.fadeIn 100, =>
#          @dom.css {height: 'auto'}
      @panel_complate.fadeIn 100

  showPanel: =>
