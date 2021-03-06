class @main extends @template '../lp'
  route : '/send_code'
  model : 'main/second_step'
  title : "Отправьте код подтверждения"
  tags  : -> 'enter'
  access : ['other']
  redirect : {
    'tutor' : 'tutor/search_bids'
    'pupil' : 'main/first_step'
  }
  tree : =>
    content : @module '$'  :
      depend : [
        @module 'lib/crypto'
        @module 'lib/lzstring'
      ]
      newCode_button    : @module 'tutor/button' :
        selector  : 'new_code'
        text      : 'Отправить новый код'
      code           : @module 'tutor/forms/input_m' :
        replace : [
          "[^\\d-\\(\\)\\@\\w\\+\\s\\.]"
        ]
        name        : 'email'
        selector    : 'registration'
        text1       : 'Введите код :'
        input_icon  : 'icon_info'
      continue_button    : @module 'link_button_m' :
        href      : '/new_password'
        selector  : 'send_code'
        text      : 'Продолжить'
