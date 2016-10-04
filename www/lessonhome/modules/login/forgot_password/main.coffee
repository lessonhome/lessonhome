

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

    {status,err, way} = yield @$send('passwordRestore',{
      login: login
    })
    console.log status, err
    if status == 'success'
      if way == 'email'
        @dom.find('h1').text 'Спасибо!'
        @dom.find('h5').text 'Мы выслали Вам email с сылкой для восстановления пароля.'
        @dom.find('.login_row').hide()
        @dom.find('.button_row').hide()
      else if way == 'phone'
        return Feel.go '/send_code'
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
      when 'empty_login'
        @login.showError 'Введите логин'
      when 'bad_login'
        @login.showError 'Введите телефон или email'
      when 'send_later','limit_attempt', 'already_send'
        Feel.go '/send_code'
      when 'error_sms'
        @login.showError 'Неудалось отправить сообщение. Пожалуйста, повторите попытку позже'
      when 'login_not_exists'
        @login.showError 'К сожалению мы не смогли Вас найти'
      when 'email_not_exists'
        @login.showError 'К сожалению вы не привязали к анкете свой email. Для восстановления доступа позвоните нам по телефону +7 (495) 177-14-78.'
      else
        @login.showError('Внутренняя ошибка сервера. Приносим свои извинения')


