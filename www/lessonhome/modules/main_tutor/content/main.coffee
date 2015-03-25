class @main extends EE
  show : =>
    console.log @tree
    @password = @tree.password.class
    @login    = @tree.login.class
    @submit   = @tree.create_account.class
    @checkbox = @tree.agree_checkbox.class
    @submit.on 'submit', @tryRegister

    Feel.HashScrollControl @dom

  tryRegister : =>
    pass = @password.getValue()
    login = @login.getValue()
    return unless pass.length > 6
    return unless login.length > 3
    return unless @checkbox.state
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
    Feel.send( 'register',{
      password : pass
      login    : login
    }).then ({status})=>
      console.log 'register',status
      if status == 'success'
        @found.form.submit()
    .done()



