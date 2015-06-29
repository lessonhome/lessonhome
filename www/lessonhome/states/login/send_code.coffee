class @main extends @template '../main'
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
    filter_top : @module '$'  :
      depend : [
        @module 'lib/crypto'
        @module 'lib/lzstring'
      ]
      newCode_button    : @module 'tutor/button' :
        selector  : 'new_code'
        text      : 'Отправить новый код'
      code           : @module 'tutor/forms/input' :
        replace : [
          "[^\\d-\\(\\)\\@\\w\\+\\s\\.]"
        ]
        name        : 'email'
        selector    : 'registration'
        text1       : 'Введите код :'
      continue_button    : @module 'link_button' :
        href      : '/new_password'
        selector  : 'send_code'
        text      : 'Продолжить'