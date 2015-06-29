class @main extends @template '../main'
  route : '/new_password'
  model : 'main/second_step'
  title : "Новый пароль"
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
      password           : @module 'tutor/forms/input' :
        replace : [
          "[^\\d-\\(\\)\\@\\w\\+\\s\\.]"
        ]
        name        : 'email'
        type        : 'password'
        selector    : 'registration'
        text1       : 'Новый пароль'
      confirm_password    : @module 'tutor/forms/input' :
        name        : 'password'
        type        : 'password'
        selector    : 'registration'
        text1       : 'Подтвердить пароль'
      save_button    : @module 'link_button' :
        href      : '/tutor/search_bids'
        selector  : 'save_enter'
        text      : 'Сохранить и войти'