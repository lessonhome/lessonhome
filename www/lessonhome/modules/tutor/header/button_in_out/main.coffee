

class @main extends EE
  show : =>
  togglePopup : =>
    @popupVisible = !@popupVisible
    if @registered
      @popup_box.filter ":hidden"
      return
    @popup_box.toggle @popupVisible
    if @popupVisible
      @emit 'showPopup'
    else
      @emit 'hidePopup'

  hidePopup : =>
    return unless @popupVisible
    @popupVisible = false
    @popup_box.hide()
    @emit 'hidePopup'
  exit    : =>
    Feel.go '/form/tutor/logout'
  tryLogin : (e)=> Q.spawn =>
    return if @success
    e?.preventDefault?()
    pass  = @password.getValue()
    login = @login.getValue()

    ret = @js.check login,pass
    if ret?.err?
      return @showError ret.err
    login = ret.login if ret?.login?
    unless pass.substr(0,1) == '`'
      len = pass.length
      pass = LZString.compress((CryptoJS.SHA1(pass)).toString(CryptoJS.enc.Hex)).toString()
      str = ""
      for i in [0...len-1]
        str += pass[i]
      pass = str
      pass = '`'+pass
      @password.setValue pass
      @password.setFlush?()
    {status,session,err} = yield @$send( 'login',{
      password : escape pass
      login    : login
    })
    if status == 'success'
      @success = true
      Feel.formSubmit @found.form
    else if err?
      @showError err
  showError : (err)=>
    switch err
      when 'already_logined'
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


