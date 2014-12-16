class @main extends template './template'
  route : '/first_step'
  title : "first_step"
  tree : ->
    content : module '$'  :
      filter_tutor    : module 'main/filter_tutor' :
        title         : 'Выберите предмет :'
        list_subject  : module 'tutor/template/forms/drop_down_list'  :
          selector  : 'subject'
        add_subject   : module 'tutor/template/button'  :
          selector  : 'add_subject'
        chose_subject : module 'tutor/template/button'  :
          selector  : 'subject'
          text      : 'Алгебра'
        button_back   : module 'tutor/template/button'  :
          selector  : 'subject_back'
          text      : 'Назад'
        button_issue  : module 'tutor/template/button'  :
          selector  : 'issue_bid'
          text      : 'Оформить заявку сейчас'
        button_onward : module 'tutor/template/button'  :
          selector  : 'onward_block'
          text      : 'Далее'
      info_panel      : module 'main/info_panel'
      search_diagram  : module 'main/motivation_block' :
        button   : module 'tutor/template/button'  :
          selector  : 'search_button'
          text      : 'Начать поиск'
        title     : 'Найти репетитора - легко!'
        selector  : 'search_diagram'
      chose_search    : module 'main/motivation_block' :
        button   : module 'tutor/template/button' :
          selector  : 'order_call'
          text      : 'Заказать звонок'
        title     : '3 способа поиска'
        selector  : 'chose_search'
      chose_tutor     : module 'main/motivation_block'  :
        button   : module 'tutor/template/button' :
          selector  : 'start_search'
          text      : 'Начать поиск'
        title     : 'Подбор репетитора'
        selector  : 'chose_tutor'
  init : =>
    p = @tree.content.info_panel
    p.math              = 'Математические +'
    p.natural_research  = 'Естественно-научные +'
    p.philology         = 'Филологичные +'
    p.foreign_languages = 'Иностранные языки +'
    p.others            = 'Другие +'