class @main extends template './template'
  route : '/two_step'
  title : "two_step"
  tree : ->
    content : module '$'  :
      filter_tutor_two  : module 'main/filter_tutor' :
        title         : 'Выберите статус преподователя'
        list_subject  : module 'tutor/template/forms/drop_down_list'  :
          selector  : 'subject'
        chose_subject : module 'tutor/template/button'  :
          selector  : 'subject'
          text      : 'Профессор'
        button_back   : module 'tutor/template/button'  :
          selector  : 'subject_back'
          text      : 'Назад'
        button_issue  : module 'tutor/template/button'  :
          selector  : 'issue_bid'
          text      : 'Оформить заявку сейчас'
        button_onward : module 'tutor/template/button'  :
          selector  : 'onward_block'
          text      : 'Далее'
      info_pane_two        : module 'main/info_panel_two'  :
        advanced_search   : 'Расширенный поиск'
        subject           : 'Предметы'
        tutor             : 'Преподователь'
        place             : 'Место'
        price             : 'Цена'
      advanced_search       : module 'main/advanced_search'
        list_course  : module 'tutor/template/forms/drop_down_list'  :
          selector  : 'list_course'
        add_course   : module 'tutor/template/button'  :
          selector  : 'course'

