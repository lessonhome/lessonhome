class @main
  tree : => module '$' :
    logo      : module '$/logo'
    top_menu : module '$/top_menu' :
      items     : @exports()
    icons     : @exports()
    back_call : module '$/back_call'  :
      city            : 'Москва'
      call_back_popup : state '../main/call_back_popup' :
        selector: 'header'

    button_in_out :  module '$/button_in_out' :
      title       : 'Выход'
      login       :  module './forms/input'  :
        placeholder : 'Логин'
      password   :  module './forms/input'  :
        placeholder : 'Пароль'
      enter       : module './button' :
        text  : 'Войти'
        selector      : 'in_out'