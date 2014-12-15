class @main extends template './template'
  route : '/'
  title : "title"
  tree : ->
    content : module 'main_page'  :
      filter_tutor    : module '//filter_tutor' :
        list_subject  : module 'tutor/template/forms/drop_down_list'  :
          selector    : 'subject'
        add_subject : module 'tutor/template/button'  :
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
      subject_panel   : module '//subject_panel'  :
        math              : 'Математические +'
        natural_research  : 'Естественно-научные +'
        philology         : 'Филологичные +'
        foreign_languages : 'Иностранные языки +'
        others            : 'Другие +'
      search_diagram  : module '//search_diagram' :
        search_button   : module 'tutor/template/button'  :
          selector  : 'search_button'
          text      : 'Начать поиск'
      chose_search    : module '//chose_search' :
        order_call   : module 'tutor/template/button' :
          selector  : 'order_call'
          text      : 'Заказать звонок'
      chose_tutor     : module '//chose_tutor'  :
        start_search   : module 'tutor/template/button' :
          selector  : 'start_search'
          text      : 'Начать поиск'