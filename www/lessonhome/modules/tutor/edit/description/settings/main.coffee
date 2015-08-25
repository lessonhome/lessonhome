class @main
  Dom   : =>
    @hint = @found.hint
    @close_block = @found.close_block
    # notice
    @new_orders_toggle = @tree.new_orders_toggle.class
    @notice_sms_checkbox = @tree.notice_sms_checkbox.class
    @notice_email_checkbox = @tree.notice_email_checkbox.class
    @callback_toggle = @tree.callback_toggle.class
    @callback_comment = @tree.callback_comment.class
    @save_button_notice = @tree.save_button_notice.class
    # change login
    @new_login = @tree.new_login.class
    @password  = @tree.password.class
    @change_button_login = @tree.change_button_login.class
    # email
    @new_email = @tree.new_email.class
    # password
    @old_password = @tree.old_password.class
    @new_password = @tree.new_password.class
    @confirm_password = @tree.confirm_password.class
    @save_button_password = @tree.save_button_password.class

  show  : =>
    @callback_toggle = @tree.callback_toggle.class
    @callback_toggle.on 'sec_active', =>
      #setTimeout(=> $(@hint).hide('slow'); 2000)
      #(function() { $("#elem").hide('slow'); }, 2000);
      #@hint.show()
    #setTimeout(function() { $("#elem").hide('slow'); }, 2000);

    @close_block.on 'click', =>
      @hint.hide()

    @save_button_notice.on 'submit', @b_save_notice
    @save_button_password.on 'submit', @trySavePassword

    @change_button_login.on 'submit', @tryChangeLogin

    @$send( 'loginUpdate',{
      getLogin : true
    }).then (login)=>
      document.getElementsByClassName('text select')[0].innerHTML = login

  trySavePassword : =>
    pass    = @old_password.getValue()
    newpass = @new_password.getValue()
    confirm_pass = @confirm_password.getValue()

    if newpass!=confirm_pass
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
      #@old_password.setValue pass
      @hashedPassword = true
    unless newpass.substr(0,1) == '`'
      len = newpass.length
      newpass = LZString.compress((CryptoJS.SHA1(newpass)).toString(CryptoJS.enc.Hex)).toString()
      str = ""
      for i in [0...len-1]
        str += newpass[i]
      newpass = str
      newpass = '`'+newpass
    @$send( 'passwordUpdate',{
      password : pass
      newpassword : newpass
    }).then ({status,err})=>
      #console.log 'login Changed', arguments
      console.log 'status : '+status
      if status == 'success'
        @success = true
        $('body,html').animate({scrollTop:0}, 500)

        @old_password.setValue ''
        @new_password.setValue ''
        @confirm_password.setValue ''
      else
        #@printErrors err
        console.log 'ERROR', err



  tryChangeLogin : =>
    pass  = @password.getValue()
    login = @new_login.getValue()

    ret = @js.check login,pass

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
    @$send( 'loginUpdate',{
      password : pass
      newlogin    : login
    }).then ({status,err})=>
      #console.log 'login Changed', arguments
      console.log 'status : '+status
      if status == 'success'
        @success = true
        $('body,html').animate({scrollTop:0}, 500)
      else
        @printErrors err

  b_save_notice : =>
    @save_notice().then (success)=>
      if success
        ###
        @$send('./save',@progress).then ({status})=>
          if status=='success'
            return true
        ###
        console.log 'IS SEND!!!'
        $('body,html').animate({scrollTop:0}, 500)
        #@changes_field.fadeIn()
        return true
    .done()

  save_notice : => Q().then =>
    if @check_form()
      return @$send('./save_notice',@getDataNotice())
      .then @onReceive
    else
      return false

  b_save_password : =>
    @save_password().then (success)=>
      if success
        console.log 'IS SEND!!!'
        $('body,html').animate({scrollTop:0}, 500)
        #@changes_field.fadeIn()
        return true
    .done()

  save_password : => Q().then =>
    if @check_password()
      return @$send('./save_password',@getDataPassword())
      .then @onReceive
    else
      return false

  onReceive : ({status,errs,err})=>
    if err?
      errs?=[]
      errs.push err
    if status=='success'
      return true
    if errs?.length
      for e in errs
        @parseError e
    return false

  check_form : =>
    return true
    #errs = @js.check @getData()
    #for e in errs
     # @parseError e
    #return errs.length==0

  check_password : =>
    errs = @js.checkPassword @getData()

  getDataNotice : =>
    get_notifications = []
    if @notice_sms_checkbox.getValue() then get_notifications.push 'sms'
    if @notice_email_checkbox.getValue() then get_notifications.push 'email'
    return {
      new_orders: @new_orders_toggle.getValue()
      get_notifications: get_notifications
      call_operator_possibility: @callback_toggle.getValue()
      callback_comment: @callback_comment.getValue()
    }

  getDataPassword : =>
    return {
      old : @old_password.getValue()
      new : @new_password.getValue()
      confirm : @confirm_password.getValue()
    }

  parseError : (err)=>
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    #switch err
    #empty
    #correct

  printErrors : (err)=>
    switch err
      when 'wrong_password'
        @password.showError 'Неверный пароль'
        console.log err
      when 'login_exists'
        @new_login.showError 'Такой логин занят'
        console.log err
      when 'already_logined'
        @new_login.showError "Кажется вы уже вошли. Сначала надо выйти!"
        @password.showError()
    #href = "/tutor/profile"
    #window.location =  href
    #console.log err
      when 'bad_login'
        @new_login.showError 'Используйте для логина корректный телефон или email'
        console.log err
      when 'bad_password'
        @password.showError 'Плохой пароль'
        console.log err
      when 'empty_login_form'
        @new_login.showError 'Введите телефон или email'
      when 'empty_password_form'
        @password.showError 'Введите пароль для нового аккаунта'
      when 'short_login'
        @new_login.showError 'Слишком короткий логин'
        console.log err
      when 'short_password'
        @password.showError 'Слишком короткий пароль'
        console.log err
      else
        @new_login.showError()
        @password.showError 'что-то пошло не так'
