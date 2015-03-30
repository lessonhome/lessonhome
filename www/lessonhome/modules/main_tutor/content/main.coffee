class @main extends EE
  show : =>
    console.log @tree
    @password = @tree.password.class
    @hashedPassword = false
    @login    = @tree.login.class
    @submit   = @tree.create_account.class
    @checkbox = @tree.agree_checkbox.class
    @checkbox_error = @found.checkbox_error
    @submit.on 'submit', @tryRegister
    @found.form.on 'submit', (e)=> e.preventDefault() unless @success
    @success = false
    @login.on 'pressingEnter', =>
      @password.setFocus()
      if @hashedPassword
        @password.clearField()
        @hashedPassword = false
    @password.on 'pressingEnter', @tryRegister
    @checkbox.on 'change', (state)=>
      if state then @checkbox_error.hide()
    Feel.HashScrollControl @dom

  tryRegister : (e)=>
    return if @success
    #@$send( './loginExists',login).then (exists)=> console.log exists
    e?.preventDefault?()
    pass = @password.getValue()
    login = @login.getValue()
    #return unless pass.length>=5
    #return unless login.length > 3

    err = @js.check login,pass,@checkbox.state
    @printErrors err.err if err?.err?
    return if err?
    console.log pass
    unless pass.substr(0,1) == '`'
      len = pass.length
      pass = LZString.compress((CryptoJS.SHA1(pass)).toString(CryptoJS.enc.Hex)).toString()
      str = ""
      for i in [0...len-1]
        str += pass[i]
      pass = str
      pass = '`'+pass
      @password.setValue pass
      @hashedPassword = true
      @password.setFlush?()
    console.log pass
    @$send( 'register',{
      password : pass
      login    : login
    }).then ({status,err})=>
      console.log 'register',status
      if status == 'success'
        @success = true
        @found.form.submit()
      else
        @printErrors err


    .done()
  printErrors : (err)=>
    #console.log err
    switch err
      when 'wrong_password'
        @password.outErr 'Неверный пароль'
        console.log err
      when 'login_exists'
        @login.outErr 'Такой логин занят'
        console.log err
      when 'already_logined'
        href = "/tutor/profile"
        window.location =  href
        console.log err
      when 'bad_login'
        @login.outErr 'Некорректный логин. Используйте для логина символы латинского алфавита и цифры'
        console.log err
      when 'bad_password'
        @password.outErr 'Плохой пароль'
        console.log err
      when 'empty_login_form'
        @login.outErr 'Заполните форму'
      when 'empty_password_form'
        @password.outErr 'Заполните форму'
      when 'short_login'
        @login.outErr 'Слишком короткий логин'
        console.log err
      when 'short_password'
        @password.outErr 'Слишком короткий пароль'
        console.log err
      when 'select_agree_checkbox'
        @checkbox_error.show()
        #alert 'Чекбокс'
      else
        console.log err

