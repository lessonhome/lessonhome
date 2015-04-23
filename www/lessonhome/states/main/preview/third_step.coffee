class @main extends template '../preview'
  route : '/third_step'
  model : 'main/third_step'
  title : "выберите место занятия"
  tags  : -> 'pupil:main_search'
  access : ['pupil','other']
  redirect : {
    'default' : 'main/first_step'
  }
  tree : =>
    popup       : @exports()
    tag         : 'pupil:main_search'
    filter_top  : state '../filter_top' :
      title : 'Выберите место занятия :'
      at_home_button      : module 'tutor/forms/location_button'  :
        selector  : 'top_filter'
        text      : 'У себя'
      in_tutoring_button  : module 'tutor/forms/location_button'  :
        selector  : 'top_filter'
        text      : 'У репетитора'
      remotely_button     : module 'tutor/forms/location_button'  :
        selector  : 'top_filter'
        text      : 'Удаленно'
      address_input       : module 'tutor/forms/drop_down_list'  :
        placeholder : 'Даниловский'
        selector    : 'area'
      link_forward    :  '/fourth_step'
      link_back       :  '/second_step'
