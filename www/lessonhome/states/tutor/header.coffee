class @main
  tree : => module '$' :
    depend : [
      module 'lib/crypto'
      module 'lib/lzstring'
    ]
    logo      : module '$/logo'
    top_menu : module '$/top_menu' :
      items     : @exports()
    icons     : @exports()
    back_call : module '$/back_call'  :
      city            : 'Москва'
      call_back_popup : state '../main/call_back_popup' :
        selector: 'header'

    button_in_out :  module '$/button_in_out' :
      registered  : data('checkRegistered').check()
      login       :  module './forms/input'  :
        selector    : 'in_out'
        placeholder : 'Логин'
        name        : 'email'
      password   :  module './forms/input'  :
        type        : 'password'
        selector    : 'in_out'
        placeholder : 'Пароль'
        name        : 'password'
      enter       : module './button' :
        text  : 'Войти'
        selector      : 'in_out'
