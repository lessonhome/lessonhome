class @main extends template '../main'
  route : '/main_tutor'
  tags  : -> 'pupil:main_tutor'
  model : 'main/registration'
  title : "Регистрация"
  tree : ->
    popup : @exports()
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
        pattern: '.{6,}'
        errMessage  : 'Пароль должен быть не меньше 6-ти символов'
      password_hint   : module 'tutor/hint' :
        selector : 'small'
        text     : 'Придумайте достаточно сложный пароль минимум 6 символов'
      checkbox        : module 'tutor/forms/checkbox'
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




