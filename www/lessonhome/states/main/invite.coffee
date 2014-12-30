class @main extends template '../main'
  tree : ->
    filter_top  : state 'main/invite/top'
    content     : module 'main/first_step/motivation' :
      search_diagram  : module 'main/motivation_block' :
        button   : module 'tutor/button'  :
          selector  : 'search_button'
          text      : 'Начать поиск'
        title     : 'Найти репетитора - легко!'
        selector  : 'search_diagram'
      choose_search    : module 'main/motivation_block' :
        button   : module 'tutor/button' :
          selector  : 'order_call'
          text      : 'Заказать звонок'
        title     : '3 способа поиска'
        selector  : 'choose_search'
      choose_tutor     : module 'main/motivation_block'  :
        button   : module 'tutor/button' :
          selector  : 'start_search'
          text      : 'Начать поиск'
        title     : 'Подбор репетитора'
        selector  : 'choose_tutor'
