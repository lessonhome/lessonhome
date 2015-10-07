class @main
  Dom: =>
    @name = @tree.first.class.tree.name.class
    @phone = @tree.first.class.tree.phone.class
    @email = @tree.first.class.tree.email.class
    @subject=@tree.subject.class
    @second_block=@found.second_block
  show : =>
    if !@subject.getValue()
      @subject.on 'focus', =>
        @second_block.show('slow')
    else  @second_block.show('slow')
  parseError: (err) =>
    if err['name']? then @name.showError 'Введите более короткое имя'
    if err['phone']?
      if err['phone'] is 'empty_field' then @phone.showError 'Введите телефон'
      else @phone.showError 'Введите корректный телефон'
    if err['email']? then @email.showError 'Введите корректный E-mail'

