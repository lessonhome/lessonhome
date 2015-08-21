

class @main extends EE
  Dom  : =>
  show : =>

    @send_button = @tree.send_button.class
    @login = @tree.login.class

    @send_button.on 'submit', @sendAuthMail

  sendAuthMail: =>

    @$send( 'passwordRestore',{
      login: @login.getValue()
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


