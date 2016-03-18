
class @main extends @template '../lp'
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
      login           : @module 'tutor/forms/input_m' :
        replace : [
          "[^\\d-\\(\\)\\@\\w\\+А-Яа-яёЁ\\s\\.]"
        ]
        name        : 'email'
        selector    : 'registration'
        text1       : 'Введите ваш телефон или e-mail'
        input_icon  : 'icon_mail_outline'
      password        : @module 'tutor/forms/input_m' :
        name        :'password'
        type        : 'password'
        selector    : 'registration'
        text1       : 'Придумайте пароль'
        input_icon  : 'icon_lock_outline'
      agree_checkbox        : @module 'tutor/forms/checkbox' :
        value : true
        selector: 'small'
      create_account  : @module 'link_button_m' :
        href      : 'tutor/profile/first_step'
        selector  : 'main_page_motivation_test'
        text      : 'СОЗДАТЬ АККАУНТ'




