

class @main extends EE
  Dom  : =>
  show : =>

    @send_button = @tree.send_button.class
    @login = @tree.login.class

    @send_button.on 'submit', @sendAuthMail

  sendAuthMail: => Q.spawn =>
    login = @login.getValue()

    ret = @js.check login
    if ret?.err?
      return @showError ret.err
    login = ret.login if ret?.login?

    {status,err} = yield @$send('passwordRestore',{
      login: login
    })
    console.log status
    if status == 'success'
      @dom.find('.title').text 'Спасибо!'
      @dom.find('.text').text 'Мы выслали Вам email с сылкой для восстановления пароля.'
      @dom.find('.login').hide()
      @dom.find('.buttons').hide()
      #return Feel.go '/send_code'
    if status == 'failed'
      if err
        @showError err
      else
        @showError('login_not_exists')

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
        @login.showError 'К сожалению мы не смогли Вас найти'
      when 'email_not_exists'
        @login.showError 'К сожалению вы не привязали к анкете свой email. Для восстановления доступа позвоните нам по телефону +7 (495) 181-03-73'
      else
        @login.showError()
        @password.showError "что-то пошло не так"


