class @main extends EE
  show : =>
    console.log @tree
    @password = @tree.password.class
    @login    = @tree.login.class
    @submit   = @tree.create_account.class
    @checkbox = @tree.agree_checkbox.class
    @submit.on 'submit', @tryRegister
    @found.form.on 'submit', @tryRegister
    @success = false
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
        console.log err
      when 'bad_login'
        @login.outErr 'Некорректный логин. Используйте для логина символы латинского алфавита и цифры'
        console.log err
      when 'bad_password'
        @password.outErr 'Плохой пароль'
        console.log err
      when 'short_login'
        @login.outErr 'Слишком короткий логин'
        console.log err
      when 'short_password'
        @password.outErr 'Слишком короткий пароль'
        console.log err
      when 'select_agree_checkbox'
        alert 'Чекбокс'
      else
        console.log err

