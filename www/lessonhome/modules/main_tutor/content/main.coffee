class @main extends EE
  Dom: =>
    @motivation_create_profile = @found.motivation_create_profile
  show : =>
    console.log @tree
    @password = @tree.password.class
    @found.terms_link.click =>
      Feel.root.tree.popup?.class?.open?()
      return false
    @hashedPassword = false
    @login    = @tree.login.class
    @submit   = @tree.create_account.class
    @checkbox = @tree.agree_checkbox.class
    @checkbox_error = @found.checkbox_error
    @submit.on 'submit', @tryRegister
    @found.form.on 'submit', (e)=> e.preventDefault() unless @success
    @success = false
    @checkbox.on 'change', (state)=> @checkbox_error.hide()
    Feel.HashScrollControl @dom
    @login.on 'submit',=>
      @password.focus()
    @login.on 'focus',=>
      if @hashedPassword
        @password.setValue ''
        @hashedPassword = false
    @password.on 'submit',@tryRegister
    #$(@motivation_create_profile).on 'click', =>
    #  $("body").animate({"scrollTop":0},"slow")
    #  @login.onFocus()

  tryRegister : (e)=>
    return if @success
    #@$send( './loginExists',login).then (exists)=> console.log exists
    e?.preventDefault?()
    pass = @password.getValue()
    login = @login.getValue()
    #unless @checkEmail login
    #  unless login = @checkPhone login
    #    return @login.showError 'Введите корректный телефон или email'
    #return unless pass.length>=5
    #return unless login.length > 3

    ret = @js.check login,pass,@checkbox.state
    @printErrors ret.err if ret?.err?
    return if ret?.err?
    login = ret.login if ret?.login?
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
    @$send( 'register',{
      password : escape pass
      login    : login
    }).then ({status,err})=>
      console.log 'register',arguments
      if status == 'success'
        Feel.sendAction 'register'
        @success = true
        Feel.formSubmit @found.form
        #@found.form.submit()
      else
        @printErrors err


    .done()
  checkEmail : (login)=>
    re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i
    re.test login
  checkPhone : (login)=>
    return null unless login.match /^[-\+\d\(\)\s]+$/
    p = login.replace /\D/,""
    return null if p.length > 11
    if p.length == 11
      if p.match /^[7|8]/
        p = p.substr 1
      else return null
    if p.length == 7 || p.length == 10
      return p
    return null

  printErrors : (err)=>
    #console.log err
    switch err
      when 'wrong_password'
        @password.showError 'Неверный пароль'
        console.log err
      when 'login_exists'
        @login.showError 'Такой логин занят'
        console.log err
      when 'already_logined'
        @login.showError "Кажется вы уже вошли. Сначала надо выйти!"
        @password.showError()
        #href = "/tutor/profile"
        #window.location =  href
        #console.log err
      when 'bad_login'
        @login.showError 'Используйте для логина корректный телефон или email'
        console.log err
      when 'bad_password'
        @password.showError 'Плохой пароль'
        console.log err
      when 'empty_login_form'
        @login.showError 'Введите телефон или email'
      when 'empty_password_form'
        @password.showError 'Введите пароль для нового аккаунта'
      when 'short_login'
        @login.showError 'Слишком короткий логин'
        console.log err
      when 'short_password'
        @password.showError 'Слишком короткий пароль'
        console.log err
      when 'select_agree_checkbox'
        @checkbox_error.show()
        #alert 'Чекбокс'
      else
        @login.showError()
        @password.showError 'что-то пошло не так'
