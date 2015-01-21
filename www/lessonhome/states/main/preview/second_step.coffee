class @main extends template '../preview'
  route : '/second_step'
  model : 'main/second_step'
  title : "выберите статус преподователя"
  tree : ->
    filter_top  : state '../filter_top':
      title : 'Выберите статус преподователя :'
      list_subject    : module 'tutor/forms/drop_down_list' :
        selector    : 'filter_top'
        placeholder : 'Например студент'
      choose_subject  : module 'tutor/button'  :
        selector  : 'choose_subject'
        text      : 'Преподаватель вуза'
        close     : true
