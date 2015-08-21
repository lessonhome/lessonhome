


@handler = ($, data)->

  mail = yield Main.service 'mail'

  if data.login.match '@'

    mail.send(
      'restore_password.html'
      'arsereb@gmail.com'
      'Восстановление пароля'
      {
        name: ', '+data.login
        login: 'test_pass_restore'
        onceAuth: 'http://127.0.0.1:8081/once_auth/'+yield mail.genResetToken()
      }
    ).done()
  else
    console.log 'mail: Signed up with phone number, can\'t send mail'

