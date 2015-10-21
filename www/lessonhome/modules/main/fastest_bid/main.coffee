class @main
  constructor: ->
    $W @
  Dom : =>
    @panel_form = @found.form
    @panel_complate = @found.complate
    @panel_wrap = @found.wrap
    @name = @tree.field_name.class
    @phone = @tree.field_phone.class
  show : =>
    @name.on "focus", =>
      @sendTouch 'form_interaction','name'
    @phone.on "focus", =>
      @sendTouch 'form_interaction','telephone'
    @name.on "change", =>
      @found.btn.find('>div').fadeIn()
    @phone.on "change", =>
      @found.btn.find('>div').fadeIn()
    @tree.btn_send.class.on 'submit', => @sendTouch 'form_interaction','button_click'
    @tree.btn_more.class.on 'click', => @sendTouch 'goto_full'
    @attach = Feel.bid_attached
    @phone.on 'end', @sendForm

    @tree.btn_send.class.on 'submit', => Q.spawn =>
      correct = yield @sendForm()
      if correct then @showComplete()
  sendTouch : (action, label)=>
    Feel.sendGActionOnceIf(6000,'bid_quick',action,label)
  sendForm : =>
    error = yield @attach.sendForm()
    ###
    if error['phone']?
      @tree.field_phone.class.showError()
      return false
    if error['name']?
      @tree.field_name.class.showError()
      return false
    ###
    if error['phone']?
      Feel.bid_attached.showForm()
      return false
    Feel.sendGActionOnceIf(6000,'bid_quick','form_submit')
    return true
  showComplete: =>
    @panel_wrap.css height: @panel_wrap.outerHeight()
    @panel_form.fadeOut 200, =>
      @panel_complate.fadeIn 100
