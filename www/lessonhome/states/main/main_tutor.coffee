class @main extends template '../main'
  route : '/main_tutor'
  model : 'main/registration'
  title : "Регистрация"
  tree : -> module 'main_tutor' :
    header  : state 'tutor/header'
    content : module 'main_tutor/content'  :
      login           : module 'tutor/forms/input' :
        text : 'Введите ваш телефон или email адрес'
      login_hint      : module 'tutor/hint' :
        selector : 'small'
        text     : ''
      password        : module 'tutor/forms/input' :
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

      how_it_works  : module '../main/motivation_content/motivation_block' :
        margin    : 27
        button   : module 'tutor/button' :
          selector  : 'check_in_first'
          text      : 'Зарегистрируйтесь прямо сейчас!'
        title     : 'Как это работает?'
        img  :
          src : F('main_tutor/main_easy.png')
          w   : 703
          h   : 421
        text  :
          start_search    : 'Условия'
          view_tutor      : 'Регистрация'
          selected_tutor  : 'Заполните профиль'
          issue_bid       : 'Поиск ученика'
          meet            : 'Получите контакты'
          learn           : 'Начните занятия'

      choose_search   : module '../main/motivation_content/motivation_block' :
        margin    : 58
        button    : module 'tutor/button'  :
          selector  : 'order_call'
          text      : 'Заказать звонок'
        title     : '3 способа поиска'
        img  :
          src : F('main/main_search.png')
          w   : 648
          h   : 477
        text  :
          select_tutor_self : 'Подберите себе<br>репетитора сами'
          call_us           : 'Позвоните нам<br>и мы все сделаем за вас'
          issue_bid_help    : 'Оформите заявку<br>и наша команда<br>предложит вам<br>разные варианты'












