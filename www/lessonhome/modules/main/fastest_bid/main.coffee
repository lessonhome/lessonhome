class @main
  constructor: ->
    Wrap @
  Dom : =>
    @panel_form = @found.form
    @panel_complate = @found.complate
    @panel_wrap = @found.wrap
    @name = @tree.field_name.class
    @phone = @tree.field_phone.class
  show : =>
    @name.on "focus", => @sendTouch.out 'form_interaction','name'
    @phone.on "focus", => @sendTouch.out 'form_interaction','telephone'
    @tree.btn_send.class.on 'submit', => @sendTouch.out 'form_interaction','button_click'
    @tree.btn_more.class.on 'click', => @sendTouch.out 'goto_full'
    @attach = Feel.bid_attached
    @phone.on 'end', @sendForm.out

    @tree.btn_send.class.on 'submit', => Q.spawn =>
      correct = yield @sendForm()
      if correct then @showComplete()
  sendTouch : (action, label)=>
    Feel.sendGActionOnceIf(6000,'bid_quick',action,label)
  sendForm : =>
    error = yield @attach.sendForm()
    if error['phone']?
      @tree.field_phone.class.showError()
      return false
    if error['name']?
      @tree.field_name.class.showError()
      return false
    Feel.sendGActionOnceIf(6000,'bid_quick','form_submit')
    return true
  showComplete: =>
    @panel_wrap.css height: @panel_wrap.outerHeight()
    @panel_form.fadeOut 200, =>
#      @dom.animate {height :@panel_complate.outerHeight(true)}, 200, =>
#        @panel_complate.fadeIn 100, =>
#          @dom.css {height: 'auto'}
      @panel_complate.fadeIn 100