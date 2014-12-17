class @main extends template './template'
  route : '/main_tutor'
  title : "title"
  tree : ->
    content : module 'main_tutor'  :
      login           : module 'tutor/template/forms/input' :
        text : 'Введите ваш телефон или email адрес'
      login_hint      : module 'tutor/template/hint' :
        selector : 'small'
        text     : ''
      password        : module 'tutor/template/forms/input' :
        text : 'Придумайте пароль'
      password_hint   : module 'tutor/template/hint' :
        selector : 'small'
        text     : ''
      checkbox        : module 'tutor/template/forms/checkbox' :
        selector : 'check_in'
      create_account  : module 'tutor/template/button' :
        selector  : 'create_account'
        text      : 'Создать аккаунт'
      check_in_first  : module 'tutor/template/button' :
        selector  : 'check_in_first'
        text      : 'Зарегистрируйся прямо сейчас!'
      check_in_second : module 'tutor/template/button' :
        selector  : 'check_in_second'
        text      : 'Прямо сейчас!'
      callback    : module 'tutor/template/button' :
        selector  : 'callback'
        text      : 'Заказать звонок'