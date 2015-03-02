class @main
  tree : => module '$' :
    logo      : module '$/logo'
    top_menu : module '$/top_menu' :
      items     : @exports()
    icons     : @exports()
    back_call : module '$/back_call'  :
      city            : 'Москва'
      call_back_popup : module 'call_back_popup' :
        selector : 'header'
        name        : module './forms/input'  :
          placeholder : 'Ваше имя'
        tel_number  : module './forms/input'  :
          placeholder : 'Телефон'
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
        placeholder : 'Логин'
      password   :  module './forms/input'  :
        placeholder : 'Пароль'
      enter       : module './button' :
        text  : 'Войти'
        selector      : 'in_out'