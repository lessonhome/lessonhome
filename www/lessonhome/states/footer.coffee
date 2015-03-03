class @main
  tree : => module '$' :
    logo : module 'tutor/header/logo'
    back_call : module 'tutor/header/back_call'  :
      selector: 'footer'
      call_back_popup : module 'call_back_popup' :
        selector : 'footer'
        name        : module 'tutor/forms/input'  :
          placeholder : 'Ваше имя'
        tel_number  : module 'tutor/forms/input'  :
          placeholder : 'Телефон'
        comments  : module 'tutor/forms/textarea' :
          placeholder : 'Комментарий'
        pupil       : module 'tutor/header/button_toggle' :
          text   : 'Я ученик'
          selector      : 'call_back_pupil inactive'
        tutor       : module 'tutor/header/button_toggle' :
          text  : 'Я репетитор'
          selector      : 'call_back_tutor inactive'
        order_call  : module 'tutor/button' :
          text  : 'Заказать звонок'
          selector      : 'call_back'