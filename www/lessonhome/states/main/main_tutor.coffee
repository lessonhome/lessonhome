class @main extends template '../main'
  route : '/main_tutor'
  tags  : -> 'pupil:main_tutor'
  model : 'main/registration'
  title : "Регистрация"
  tree : ->
    content : module 'main_tutor/content'  :
      login           : module 'tutor/forms/input' :
        selector : 'main_check_in'
        text : 'Введите ваш телефон или email адрес'
      login_hint      : module 'tutor/hint' :
        selector : 'small'
        text     : 'Придумайте достаточно сложный пароль минимум 6 символов'
      password        : module 'tutor/forms/input' :
        selector : 'main_check_in'
        text : 'Придумайте пароль'
      password_hint   : module 'tutor/hint' :
        selector : 'small'
        text     : 'Придумайте достаточно сложный пароль минимум 6 символов'
      checkbox        : module 'tutor/forms/checkbox'
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
