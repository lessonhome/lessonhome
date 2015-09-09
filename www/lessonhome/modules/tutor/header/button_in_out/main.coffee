

class @main extends EE
  Dom  : =>
    #@registered   = @tree.registered
    #@button       = @dom.find ".button"
    #@title        = @button.find ".title"
    #@popup_box    = @button.find ".popup_box"
    #@close_box    = @popup_box.find ".close_box"
    #@popupVisible = @popup_box.is ':visible'

  show : =>
    #@login    = @tree.login.class
    #@password = @tree.password.class
    #@submit   = @tree.enter.class
    #@success  = false
    #@submit.on      'submit', @tryLogin
    #@found.form.on  'submit', @tryLogin
    #@login.on 'submit',=> @password.focus()
    #@password.on 'submit', @tryLogin
    #if @registered
    #  @title.on 'click', @exit
    #else
    #  @title.on 'click', @togglePopup

    #@close_box.on 'click', @hidePopup

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
  tryLogin : (e)=>
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
    @$send( 'login',{
      password : escape pass
      login    : login
    }).then ({status,session,err})=>
      console.log 'login',status
      if status == 'success'
        @success = true
        Feel.formSubmit @found.form
        #@found.form.submit()
      else if err?
        @showError err
      ###
      else
        switch err
          when 'wrong_password'

          when 'login_not_exists'
          when 'already_logined'
          when 'bad_login'
          when 'bad_password'
          else
      ###
    .done()
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


