class @main extends template '../main'
  route : '/first_step'
  model   : 'main/first_step'
  title : "выберите предмет"
  tree : =>
    filter_top  : state './filter_top':
      title : 'Выберите предмет :'
      list_subject    : module 'tutor/forms/drop_down_list'  :
        selector    : 'filter_top'
        placeholder : 'Предмет'
        icon        : '&#9660;'
      choose_subject  : module 'tutor/button'  :
        selector  : 'choose_subject'
        text        : 'Алгебра'

    info_panel  : state './info_panel'  :
      math              : 'Математические +'
      natural_research  : 'Естественно-научные +'
      philology         : 'Филологичные +'
      foreign_languages : 'Иностранные языки +'
      others            : 'Другие +'
      selector          : 'first_step'

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