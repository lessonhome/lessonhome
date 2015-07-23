class @main extends @template '../preview'
  route : '/third_step'
  model : 'main/third_step'
  title : "выберите место занятия"
  forms : ['pupil']
  tags  : -> 'pupil:main_search'
  access : ['pupil','other']
  redirect : {
    'tutor' : 'tutor/profile'
  }
  tree : =>
    popup       : @exports()
    tag         : 'pupil:main_search'
    filter_top  : @state '../filter_top' :
      title : 'Выберите место занятия :'
      at_home_button      : @module 'tutor/forms/location_button'  :
        selector  : 'top_filter'
        text      : 'У себя'
        $form     : pupil : 'isPlace.pupil'
      in_tutoring_button  : @module 'tutor/forms/location_button'  :
        selector  : 'top_filter'
        text      : 'У репетитора'
        $form     : pupil : 'isPlace.tutor'
      remotely_button     : @module 'tutor/forms/location_button'  :
        selector  : 'top_filter'
        text      : 'Удаленно'
        $form     : pupil : 'isPlace.other'
      address_input       : @module 'tutor/forms/drop_down_list'  :
        placeholder : ''
        selector    : 'area'
        text        : 'Район :'
        smart : true
        self : true
      link_forward    :  '/fourth_step'
      link_back       :  '/second_step'
