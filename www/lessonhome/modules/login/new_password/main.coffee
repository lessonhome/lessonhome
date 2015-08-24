

class @main extends EE
  Dom  : =>
  show : =>
    @save_button = @tree.save_button.class
    @password = @tree.password.class
    @confirm_password = @tree.password.class

    @save_button.on 'submit', @newPassword

  newPassword: =>

    pass    = @password.getValue()
    confirm_pass = @confirm_password.getValue()

    if pass!=confirm_pass
      @confirm_password.showError("пароли не совпадают")
      return false

    unless pass.substr(0,1) == '`'
      len = pass.length
      pass = LZString.compress((CryptoJS.SHA1(pass)).toString(CryptoJS.enc.Hex)).toString()
      str = ""
      for i in [0...len-1]
        str += pass[i]
      pass = str
      pass = '`'+pass
      @hashedPassword = true

    @$send( 'newPassword',{
      password: pass
    })

  showError : (err)=>
    switch err
      when 'already_logined'
        return @redirect './'
        @login.showError 'Кажется вы уже вошли. Сначала надо выйти!'
        @password.showError()
      when 'empty_login'
        @login.showError 'Введите логин'
      when 'empty_password'
        @password.showError "Введите пароль"
      when 'bad_password','wrong_password'
        @password.showError 'Неверный пароль'
      when 'bad_login'
        @login.showError 'Введите телефон или email'
      when 'short_password'
        @password.showError 'Слишком короткий пароль'
      when 'login_not_exists'
        @login.showError 'Пользователь с таким логином не зарегестрирован'
      else
        @login.showError()
        @password.showError "что-то пошло не так"


