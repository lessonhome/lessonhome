class @main extends template '../preview'
  route : '/second_step'
  model : 'main/second_step'
  title : "выберите статус преподователя"
  tree : ->
    top_filter  : module '$/top_filter' :
      title         : 'Статус преподователя :'
      list_tutor    : module 'tutor/forms/drop_down_list'  :
        selector      : 'tutor'
        placeholder   : 'Преподователи'
        icon          : '&#9660;'
      add_tutor     : module 'tutor/button'  :
        selector      : 'add_tutor'
        char          : '+'
      chose_tutor   : module 'tutor/button'  :
        selector      : 'chose_tutor'
        text          : 'Профессор'
      button_back   : module 'tutor/button'  :
        selector      : 'subject_back'
        text          : 'Назад'
      button_issue  : module 'tutor/button'  :
        selector      : 'issue_bid'
        text          : 'Оформить заявку сейчас'
      button_onward : module 'tutor/button'  :
        selector      : 'onward_block'
        text          : 'Далее'
          ###
      info_pane_two        : module 'main/info_panel_two'  :
        advanced_search   : 'Расширенный поиск'
        subject           : 'Предметы'
        tutor             : 'Преподователь'
        place             : 'Место'
        price             : 'Цена'
###