class @main extends @template '../lp'
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
    content : @module '$'  :
      depend : [
        @module 'lib/crypto'
        @module 'lib/lzstring'
      ]
      login           : @module 'tutor/forms/input_m' :
        replace : [
          "[^\\d-\\(\\)\\@\\w\\+\\s\\.]"
        ]
        name        : 'email'
        selector    : 'registration'
        text1       : 'Телефон или email'
        input_icon  : 'person'
      send_button    : @module 'link_button_m' :
        selector  : 'take_code'
        text      : 'Отправить'
        active : false
