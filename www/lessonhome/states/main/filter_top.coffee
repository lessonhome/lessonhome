class @main
  tree : => module '$' :
      title           : 'Выберите предмет :'
      list_subject    : module 'tutor/forms/drop_down_list'  :
        selector    : 'filter_top'
        placeholder : 'Предметы'
        icon        : '&#9660;'
      choose_subject  : module 'tutor/button'  :
        selector  : 'choose_subject'
        text      : 'Алгебра'
      button_back     : module 'tutor/button'  :
        selector  : 'subject_back'
        text      : 'Назад'
      button_issue    : module 'tutor/button'  :
        selector  : 'issue_bid'
        text      : 'Оформить заявку сейчас'
      button_onward   : module 'tutor/button'  :
        selector  : 'onward_block'
        text      : 'Далее'
