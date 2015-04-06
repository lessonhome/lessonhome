class @main extends template '../main'
  access : ['other']
  redirect : {
    'pupil' : '/first_step'
    'tutor' : '/tutor/search_bids'
  }
  route : '/main_tutor'
  tags  : -> 'pupil:main_tutor'
  model : 'main/registration'
  title : "Регистрация"
  tree : ->
    popup : @exports()
    content : module 'main_tutor/content'  :
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
        text1       : 'Введите ваш телефон или email адрес'
      password        : module 'tutor/forms/input' :
        name        :'password'
        type        : 'password'
        selector    : 'fast_bid'
        text1       : 'Придумайте пароль'
      agree_checkbox        : module 'tutor/forms/checkbox' :
        state : true
      create_account  : module 'link_button' :
        href      : 'tutor/profile/first_step'
        selector  : 'create_account'
        text      : 'Создать аккаунт'
      check_in_first  : module 'tutor/button' :
        selector  : 'check_in_first'
        text      : 'Зарегистрируйся прямо сейчас!'
      check_in_second : module 'tutor/button' :
        selector  : 'check_in_second'
        text      : 'Прямо сейчас!'
      callback    : module 'link_button' :
        selector  : 'order_call'
        text      : 'Заказать звонок'
        href      : '/main_tutor_callback'




