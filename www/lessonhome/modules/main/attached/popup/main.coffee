class @main
  Dom: =>
    @name = @tree.first.class.tree.name.class
    @phone = @tree.first.class.tree.phone.class
    @email = @tree.first.class.tree.email.class
    @subject=@tree.subject.class
    @second_block=@found.second_block
  show : =>
    @name.on "focus", => @sendTouch 'form_interaction','name'
    @phone.on "focus", => @sendTouch 'form_interaction','phone'
    @email.on "focus", => @sendTouch 'form_interaction','email'
    @subject.on "focus", => @sendTouch 'form_interaction','subject'
#    @second_block "focus", => @sendTouch 'form_interaction','second_block'

    if !@subject.getValue()
      @subject.on 'focus', =>
        @second_block.show('slow')
    else  @second_block.show('slow')
  sendTouch : (action, label)=>
    Feel.sendGActionOnceIf(18000,'bid_full',action,label)
  parseError: (err) =>
    Feel.sendAction 'error_on_page' unless err.correct
    if err['name']? then @name.showError 'Введите более короткое имя'
    if err['phone']?
      if err['phone'] is 'empty_field' then @phone.showError 'Введите телефон'
      else @phone.showError 'Введите корректный телефон'
    if err['email']? then @email.showError 'Введите корректный E-mail'

