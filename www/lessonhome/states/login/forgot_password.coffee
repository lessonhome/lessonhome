class @main extends @template '../main'
  route : '/forgot_password'
  model : 'main/second_step'
  title : "Забыли пароль"
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
      login           : @module 'tutor/forms/input' :
        replace : [
          "[^\\d-\\(\\)\\@\\w\\+\\s\\.]"
        ]
        name        : 'email'
        selector    : 'registration'
      send_button    : @module 'link_button' :
        selector  : 'take_code'
        text      : 'Отправить'
        active : false
