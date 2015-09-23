
class @main extends @template '../main'
  route : '/main_tutor'
  tags  : -> 'pupil:main_tutor'
  model : 'main/registration'
  title : "Регистрация"
  access : ['other','pupil']
  redirect : {
    'tutor' : 'tutor/search_bids'
  }
  tree : ->
    popup : @exports()
    popup_close_href: @exports()
    content : @module 'main_tutor/content'  :
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
        text1       : 'Введите ваш телефон или email адрес'
      password        : @module 'tutor/forms/input' :
        name        :'password'
        type        : 'password'
        selector    : 'registration'
        text1       : 'Придумайте пароль'
      agree_checkbox        : @module 'tutor/forms/checkbox' :
        value : true
        selector: 'small'
      create_account  : @module 'link_button' :
        href      : 'tutor/profile/first_step'
        selector  : 'main_tutor_enter'
        text      : 'СОЗДАТЬ АККАУНТ'
      check_in_first  : @module 'tutor/button' :
        selector  : 'check_in_first'
        text      : 'Зарегистрируйся прямо сейчас!'
      check_in_second : @module 'tutor/button' :
        selector  : 'check_in_second'
        text      : 'Прямо сейчас!'
      create_profile: @module 'link_button' :
        href      : '/tutor_registration'
        active: true
        selector: 'main_page_motivation'
        text: 'СОЗДАТЬ ПРОФИЛЬ'
      callback: @module 'link_button' :
        selector: 'main_page_motivation'
        text: 'ОБРАТНЫЙ ЗВОНОК'
        active: true
        href: '/main_tutor_callback'




