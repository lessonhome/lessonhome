class @main extends template '../main'
  route : '/'
  model   : 'main/first_step'
  title : "выберите предмет"
  tree : =>
    top_filter  : module '$/top_filter' :
      title         : 'Выберите предмет :'
      list_subject  : module 'tutor/forms/drop_down_list'  :
        selector    : 'subject'
        placeholder : 'Предметы'
      add_subject   : module 'tutor/button'  :
        selector  : 'add_subject'
        char      : '+'
      chose_subject : module 'tutor/button'  :
        selector  : 'chose_subject'
        text      : 'Алгебра'
      button_back   : module 'tutor/button'  :
        selector  : 'subject_back'
        text      : 'Назад'
      button_issue  : module 'tutor/button'  :
        selector  : 'issue_bid'
        text      : 'Оформить заявку сейчас'
      button_onward : module 'tutor/button'  :
        selector  : 'onward_block'
        text      : 'Далее'
    content     : module '$/motivation' :
      search_diagram  : module 'main/motivation_block' :
        button   : module 'tutor/button'  :
          selector  : 'search_button'
          text      : 'Начать поиск'
        title     : 'Найти репетитора - легко!'
        selector  : 'search_diagram'
      chose_search    : module 'main/motivation_block' :
        button   : module 'tutor/button' :
          selector  : 'order_call'
          text      : 'Заказать звонок'
        title     : '3 способа поиска'
        selector  : 'chose_search'
      chose_tutor     : module 'main/motivation_block'  :
        button   : module 'tutor/button' :
          selector  : 'start_search'
          text      : 'Начать поиск'
        title     : 'Подбор репетитора'
        selector  : 'chose_tutor'
