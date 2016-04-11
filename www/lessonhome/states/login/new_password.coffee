class @main extends @template '../lp'
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
    content : @module '$'  :
      depend : [
        @module 'lib/crypto'
        @module 'lib/lzstring'
      ]
      password           : @module 'tutor/forms/input_m' :
        ###
        replace : [
          "[^\\d-\\(\\)\\@\\w\\+\\s\\.]"
        ]
        ###
        name        : 'password'
        type        : 'password'
        selector    : 'registration'
        text1       : 'Новый пароль'
        input_icon  : 'icon_lock_outline'
      confirm_password    : @module 'tutor/forms/input_m' :
        name        : 'password'
        type        : 'password'
        selector    : 'registration'
        text1       : 'Подтвердить пароль'
        input_icon  : 'icon_lock_outline'
      save_button    : @module 'link_button_m' :
        href      : '/tutor/search_bids'
        selector  : 'save_enter'
        text      : 'Сохранить и войти'
