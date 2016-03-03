class @main extends @template '../lp'
  route : '/enter'
  model : 'main/second_step'
  title : "вход"
  tags  : -> ['enter']
  access : ['other']
  redirect : {
    'tutor' : 'tutor/search_bids'
    'pupil' : 'main/first_step'
  }
  tree : =>
    content : @module 'login/enter' :
      hide_head_button: true
      depend : [
        @module 'lib/crypto'
        @module 'lib/lzstring'
      ]
      login           : @module 'tutor/forms/input_m' :
        replace : [
          "[^\\d-\\(\\)\\@\\w\\А-Яа-яЁё\\+\\s\\.]"
        ]
        name        : 'email'
        selector    : 'registration'
        text1       : 'Телефон или email'
        input_icon  : 'icon_person_outline'
      password        : @module 'tutor/forms/input_m' :
        name        : 'password'
        type        : 'password'
        selector    : 'registration'
        text1       : 'Пароль'
        input_icon  : 'icon_lock_outline'
      enter_button    : @module 'link_button_m' :
        href      : 'tutor/profile/first_step'
        selector  : 'enter_office'
        text      : 'Войти'
        btn_icon  : 'icon_lock_open'
#    filter_top : @module '$'
