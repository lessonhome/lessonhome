class @main extends template './main'
  route : '/enter'
  model : 'main/second_step'
  title : "вход"
  tags  : -> 'enter'
  access : ['other']
  redirect : {
    'tutor' : 'tutor/search_bids'
    'pupil' : 'main/first_step'
  }
  tree : =>
    content : module 'enter'  :
      depend : [
        module 'lib/crypto'
        module 'lib/lzstring'
      ]
      login           : module 'tutor/forms/input' :
        replace : [
          "[^\\d-\\(\\)\\@\\w\\+\\s\\.]"
        ]
        name        : 'email'
        selector    : 'fast_bid'
        text1       : 'Телефон или email'
      password        : module 'tutor/forms/input' :
        name        : 'password'
        type        : 'password'
        selector    : 'fast_bid'
        text1       : 'Пароль'
      enter_button    : module 'link_button' :
        href      : 'tutor/profile/first_step'
        selector  : 'create_account'
        text      : 'Войти'