class @main
  Dom: =>
    @name = @tree.first.class.tree.name.class
    @phone = @tree.first.class.tree.phone.class
    @email = @tree.first.class.tree.email.class
  show : =>
  parseError: (err) =>
    if err['name']? then @name.showError 'Введите более короткое имя'
    if err['phone']?
      if err['phone'] is 'empty_field' then @phone.showError 'Введите телефон'
      else @phone.showError 'Введите корректный телефон'
    if err['email']? then @email.showError 'Введите корректный E-mail'

