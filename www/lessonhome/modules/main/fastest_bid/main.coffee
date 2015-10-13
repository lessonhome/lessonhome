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
    @name.on "focus", => @sendTouch.out 'form interaction','name'
    @phone.on "focus", => @sendTouch.out 'form interaction','telephone'
    @tree.btn_send.class.on 'submit', => @sendTouch.out 'form interaction','button press'
    @tree.btn_more.class.on 'click', => @sendTouch.out 'goto full'
    @attach = Feel.bid_attached
    @phone.on 'end', @sendForm.out

    @tree.btn_send.class.on 'submit', => Q.spawn =>
      correct = yield @sendForm()
      if correct then @showComplete()
  sendTouch : (action, label)=>
    Feel.sendGActionOnceIf(6000,'bid short',action,label)
  sendForm : =>
    error = yield @attach.sendForm()
    if error['phone']?
      @tree.field_phone.class.showError()
      return false
    if error['name']?
      @tree.field_name.class.showError()
      return false
    Feel.sendGActionOnceIf(6000,'bid short','form send')
    return true
  showComplete: =>
    @panel_wrap.css height: @panel_wrap.outerHeight()
    @panel_form.fadeOut 200, =>
#      @dom.animate {height :@panel_complate.outerHeight(true)}, 200, =>
#        @panel_complate.fadeIn 100, =>
#          @dom.css {height: 'auto'}
      @panel_complate.fadeIn 100