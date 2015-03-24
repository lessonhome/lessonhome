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
        validators: {
          '0': {
            pattern: /^((\+?7)|8)?\d{10}$/.source
          }, #required using some like: (dataObject 'checker').patterns.simpleTelephon
          '1': {
            pattern: /^([a-z0-9_-]+\.)*[a-z0-9_-]+@[a-z0-9_-]+(\.[a-z0-9_-]+)*\.[a-z]{2,6}$/.source,
            #errMessage: 'Пожалуйста введите корректный email'
          }
          'errMessage': 'Пожалуйста введите телефонный номер в виде +7(xxx)xxx-xx-xx или корректный email'
        }
      password        : module 'tutor/forms/input' :
        selector : 'main_check_in'
        text : 'Придумайте пароль'
        pattern: '.{6,}'
        errMessage  : 'Пароль должен быть не меньше 6-ти символов'
      agree_checkbox        : module 'tutor/forms/checkbox'
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




