

class @main extends EE
  Dom  : =>
  show : =>

    @send_button = @tree.send_button.class
    @login = @tree.login.class

    @send_button.on 'submit', @sendAuthMail

  sendAuthMail: =>

    login = @login.getValue()

    ret = @js.check login
    if ret?.err?
      return @showError ret.err
    login = ret.login if ret?.login?

    @$send( 'passwordRestore',{
      login: login
    }).then ({status}) =>
      console.log status
      if status == 'failed'
        @showError('login_not_exists')
    .done()

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


