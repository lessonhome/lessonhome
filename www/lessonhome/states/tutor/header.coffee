class @main
  tree : => module '$' :
    logo      : module '$/logo'
    top_menu : module '$/top_menu' :
      items     : @exports()
    icons     : @exports()
    back_call : module '$/back_call'  :
      callback_popup : module 'callback_popup' :
        selector : module 'header'
        name        : module './forms/input'  :
          text : 'Имя'
        tel_number  : module './forms/input'  :
          text : 'Телефон'
        comments  : module './forms/textarea' :
          placeholder : 'Комментарий'
        pupil       : module '$/button_toggle' :
          text   : 'Я ученик'
          selector      : 'call_back_pupil inactive'
        tutor       : module '$/button_toggle' :
          text  : 'Я репетитор'
          selector      : 'call_back_tutor inactive'
        order_call  : module './button' :
          text  : 'Заказать звонок'
          selector      : 'call_back'
    button_in_out :  module '$/button_in_out' :
      title       : 'Выход'
      login       :  module './forms/input'  :
        text : 'Логин'
       password   :  module './forms/input'  :
        text : 'Пароль'
      enter       : module './button' :
        text  : 'Войти'
        selector      : 'in_out'