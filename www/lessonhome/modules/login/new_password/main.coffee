

class @main extends EE
  Dom  : =>
  show : =>
    ###
    Q.spawn =>
      redirect = yield @$send( 'newPassword',{
        check: true
      })
      console.log redirect
      if redirect
        window.location.replace 'forgot_password'

    ###
    @save_button = @tree.save_button.class
    @password = @tree.password.class
    @confirm_password = @tree.confirm_password.class

    @save_button.on 'submit', @newPassword

  newPassword: =>
    Q.spawn =>
      redirect = yield @$send( 'newPassword',{
        check: true
      })
      window.location.replace 'forgot_password' if redirect

    pass    = @password.getValue()
    confirm_pass = @confirm_password.getValue()

    ret = @js.check pass
    if ret?.err?
      return @showError ret.err

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
    Q.spawn =>
      {status,session,err} = yield @$send( 'newPassword',{
        password: escape pass
      })
      console.log 'login',status
      if status == 'success'
        window.location.replace 'tutor/profile'
      else if status == 'redirect'
        window.location.replace 'forgot_password'
      else if err?
        @showError err
  showError : (err)=>
    switch err
      when 'already_logined'
        return @redirect './'
        @password.showError 'Кажется вы уже вошли. Сначала надо выйти!'
        @confirm_password.showError()
      when 'empty_password'
        @password.showError "Введите пароль"
      when 'bad_password','wrong_password'
        @password.showError 'Неверный пароль'
      when 'short_password'
        @password.showError 'Слишком короткий пароль'
      else
        @password.showError()
        @confirm_password.showError "что-то пошло не так"


