class @main extends template '../preview'
  route : '/second_step'
  model : 'main/second_step'
  title : "выберите статус преподавателя"
  tags  : -> 'pupil:main_search'
  tree : ->
    popup       : @exports()
    tag         : 'pupil:main_search'
    filter_top  : state '../filter_top':
      title : 'Выберите статус преподавателя :'
      list_subject    : module 'tutor/forms/drop_down_list' :
        selector    : 'filter_top'
        placeholder : 'Например студент'
      choose_subject  : module 'selected_tag'  :
        selector  : 'choose_subject'
        text      : 'Преподаватель вуза'
        close     : true
      link_forward    :  '/third_step'
      link_back       :  '/first_step'