class @main
  tree : -> module '$' :
    logo      : module 'tutor/template/header/logo'
    icons     : @exports()
    back_call : module '$/back_call'
    button_in_out :  module '$/button_in_out' :
      title      : 'Выход'
    top_menu : module '$/top_menu' :
      items     : @exports()