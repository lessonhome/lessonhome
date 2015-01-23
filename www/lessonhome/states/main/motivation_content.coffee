class @main extends template '../main'
  tree : =>
    filter_top  : @exports()
    info_panel  : @exports()
    content     : module '$' :
      search_diagram  : module '$/motivation_block' :
        button   : module 'tutor/button' :
          selector  : 'start_search'
          text      : 'Начать поиск'
        title     : '3 способа поиска'
        img  :
          src : F('main/main_easy.png')
          w   : 703
          h   : 421
        text  :
          start_search    : 'Начните поиск'
          view_tutor      : 'Просмотрите<br>репетиторов'
          selected_tutor  : 'Выберите<br>понравившегося'
          issue_bid       : 'Оформите заявку'
          meet            : 'Познакомтесь'
          learn           : 'Занимайтесь'
      choose_search   : module '$/motivation_block' :
        margin    : true
        button    : module 'tutor/button'  :
          selector  : 'order_call'
          text      : 'Заказать звонок'
        title     : 'Найти репетитора - легко!'
        img  :
          src : F('main/main_search.png')
          w   : 648
          h   : 477
        text  :
          select_tutor_self : 'Подберите себе<br>репетитора сами'
          call_us           : 'Позвоните нам<br>и мы все сделаем за вас'
          issue_bid_help    : 'Оформите заявку<br>и наша команда<br>предложит вам<br>разные варианты'
      choose_tutor     : module '$/motivation_block'  :
        button   : module 'tutor/button' :
          selector  : 'start_search'
          text      : 'Начать поиск'
        title     : 'Подбор репетитора'
        img  :
          src : F('main/main_select.png')
          w   : 663
          h   : 519
        text  :
          more_information  : 'Подробная<br>информация'
          subject_curse     : 'Предметы и<br>курсы'
          conditions        : 'Условия'
          calendar          : 'Рассписание'
          review            : 'Отзывы'
        close     : true