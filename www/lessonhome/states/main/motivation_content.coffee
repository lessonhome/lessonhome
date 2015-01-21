class @main extends template '../main'
  tree : =>
    filter_top  : @exports()
    info_panel  : @exports()

    content     : module '$' :
      search_diagram  : module '$/motivation_block' :
        button   : module 'tutor/button'  :
          selector  : 'search_button'
          text      : 'Начать поиск'
        title     : 'Найти репетитора - легко!'
        selector  : 'search_diagram'
      choose_search    : module '$/motivation_block' :
        button   : module 'tutor/button' :
          selector  : 'order_call'
          text      : 'Заказать звонок'
        title     : '3 способа поиска'
        selector  : 'choose_search'
      choose_tutor     : module '$/motivation_block'  :
        button   : module 'tutor/button' :
          selector  : 'start_search'
          text      : 'Начать поиск'
        title     : 'Подбор репетитора'
        selector  : 'choose_tutor'
        close     : true