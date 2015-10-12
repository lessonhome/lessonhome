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
    @name.on "focus", => @sendTouch.out 'Имя'
    @phone.on "focus", => @sendTouch.out 'Телефон'
    @tree.btn_send.class.on 'submit', => @sendTouch.out 'Нажатие кнопки'
    @tree.btn_more.class.on 'click', => @sendTouch.out 'Переход к полной форме'
    @attach = Feel.bid_attached
    @phone.on 'end', @sendForm.out

    @tree.btn_send.class.on 'submit', => Q.spawn =>
      correct = yield @sendForm()
      if correct then @showComplete()
  sendTouch : (field)=>
    Feel.sendGActionOnceIf('6000','Короткая заявка','Взаимодействие с формой',field)
  sendForm : =>
    error = yield @attach.sendForm()
    if error['phone']?
      @tree.field_phone.class.showError()
      return false
    if error['name']?
      @tree.field_name.class.showError()
      return false
    return true
  showComplete: =>
    @panel_wrap.css height: @panel_wrap.outerHeight()
    @panel_form.fadeOut 200, =>
#      @dom.animate {height :@panel_complate.outerHeight(true)}, 200, =>
#        @panel_complate.fadeIn 100, =>
#          @dom.css {height: 'auto'}
      @panel_complate.fadeIn 100