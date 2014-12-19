class @main extends template '../preview'
  route : '/second_step'
  model : 'main/second_step'
  title : "second_step"
  tree : ->
    top_filter  : module '$/top_filter' :
      title         : 'Выберите предмет :'
      list_tutor  : module 'tutor/template/forms/drop_down_list'  :
        selector  : 'subject'
      add_tutor   : module 'tutor/template/button'  :
        selector  : 'add_subject'
      chose_tutor : module 'tutor/template/button'  :
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
          ###
      info_pane_two        : module 'main/info_panel_two'  :
        advanced_search   : 'Расширенный поиск'
        subject           : 'Предметы'
        tutor             : 'Преподователь'
        place             : 'Место'
        price             : 'Цена'
      advanced_search       : module 'main/advanced_search':
        list_course  : module 'tutor/template/forms/drop_down_list'  :
          selector  : 'list_course'
        add_course   : module 'tutor/template/button'  :
          selector  : 'course'
###