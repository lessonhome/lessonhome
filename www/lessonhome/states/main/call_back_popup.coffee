class @main
  tree : => module '$' :
    selector    : @exports()
    href        : @exports()
    #name        : module 'tutor/forms/input'  :
      #placeholder : 'Ваше имя'
    your_name  : module 'tutor/forms/input'  :
      placeholder : 'Ваше имя'
      selector : 'fast_bid'
    tel_number  : module 'tutor/forms/input'  :
      placeholder : 'Телефон'
      selector : 'fast_bid'
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
