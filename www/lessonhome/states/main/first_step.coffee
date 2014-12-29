class @main extends template '../main'
  route : '/first_step'
  model   : 'main/first_step'
  title : "выберите предмет"
  tree : =>
    filter_top  : state './filter_top'
    content     : module '$/motivation' :
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
