class @main
  forms : ['person','account']
  tree : => module '$' :
    selector    : @exports()
    href        : @exports()
    #name        : module 'tutor/forms/input'  :
      #placeholder : 'Ваше имя'
    your_name  : module 'tutor/forms/input'  :
      placeholder : 'Ваше имя'
      selector : 'fast_bid'
      $form : person : 'first_name'
    tel_number  : module 'tutor/forms/input'  :
      placeholder : 'Телефон'
      selector : 'fast_bid'
      $form : person : 'firstphone'
      placeholder: '+7 (___) ___–__–__'
      replace     : [
        {"^(8|7)(?!\\+7)":"+7"}
        {"^(.*)(\\+7)":"$2$1"}
        "\\+7"
        "[^\\d_]"
        {"^(.*)$":"$1__________"}
        {"^([\\d_]{0,10})(.*)$": "$1"}
        {"^([\\d_]?)([\\d_]?)([\\d_]?)([\\d_]?)([\\d_]?)([\\d_]?)([\\d_]?)([\\d_]?)([\\d_]?)([\\d_]?)$":"+7 ($1$2$3) $4$5$6-$7$8-$9$10"}
      ]
      replaceCursor     : [
        "(_)"
      ]
      selectOnFocus : true
      patterns : [
        "^\\+7 \\(\\d\\d\\d\\) \\d\\d\\d-\\d\\d-\\d\\d$" : "Введите телефон <br>в формате +7 (926) 123-45-45"
      ]
    comments  : module 'tutor/forms/textarea' :
      placeholder : 'Комментарий'
    pupil       : module 'tutor/header/button_toggle' :
      text   : 'Я ученик'
      selector      : 'call_back_pupil inactive'
    tutor       : module 'tutor/header/button_toggle' :
      text  : 'Я репетитор'
      selector      : 'call_back_tutor inactive'
      $form : account : 'activeTutor'
    order_call  : module 'tutor/button' :
      text  : 'Заказать звонок'
      selector      : 'call_back'
