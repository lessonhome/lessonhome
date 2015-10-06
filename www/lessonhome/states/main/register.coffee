
class @main extends @template '../main'
  route : '/tutor_registration'
  tags  : -> ['registration']
  model : 'main/registration'
  title : "Регистрация"
  access : ['other','pupil']
  redirect : {
    'tutor' : 'tutor/search_bids'
  }
  tree : ->
    popup : @module 'main/terms_of_cooperation'
    content : @module 'register/content'  :
      depend : [
        @module 'lib/crypto'
        @module 'lib/lzstring'
      ]
      login           : @module 'tutor/forms/input' :
        replace : [
          "[^\\d-\\(\\)\\@\\w\\+А-Яа-яёЁ\\s\\.]"
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
        selector  : 'main_page_motivation_test'
        text      : 'СОЗДАТЬ АККАУНТ'




