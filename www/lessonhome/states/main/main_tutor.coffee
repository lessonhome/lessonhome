class @main extends template '../main'
  route : '/main_tutor'
  tags  : -> 'pupil:main_tutor'
  model : 'main/registration'
  title : "Регистрация"
  tree : -> module 'main_tutor' :
    content : module 'main_tutor/content'  :
      login           : module 'tutor/forms/input' :
        selector : 'main_check_in'
        text : 'Введите ваш телефон или email адрес'
      login_hint      : module 'tutor/hint' :
        selector : 'small'
        text     : ''
      password        : module 'tutor/forms/input' :
        selector : 'main_check_in'
        text : 'Придумайте пароль'
      password_hint   : module 'tutor/hint' :
        selector : 'small'
        text     : ''
      checkbox        : module 'tutor/forms/checkbox' :
        selector : 'check_in'
      create_account  : module 'tutor/button' :
        selector  : 'create_account'
        text      : 'Создать аккаунт'
      check_in_first  : module 'tutor/button' :
        selector  : 'check_in_first'
        text      : 'Зарегистрируйся прямо сейчас!'
      check_in_second : module 'tutor/button' :
        selector  : 'check_in_second'
        text      : 'Прямо сейчас!'
      callback    : module 'tutor/button' :
        selector  : 'callback'
        text      : 'Заказать звонок'
  init : ->
    console.log @tag,@page_tags












