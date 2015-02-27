class @main extends template '../preview'
  route : '/third_step'
  model : 'main/third_step'
  title : "выберите место занятия"
  tree : =>
    filter_top  : state '../filter_top' :
      title : 'Выберите место занятия :'
      at_home_button      : module 'tutor/forms/location_button'  :
        selector  : 'at_home_button'
        text      : 'У себя'
      in_tutoring_button  : module 'tutor/forms/location_button'  :
        selector  : 'in_tutoring_button'
        text      : 'У репетитора'
      remotely_button     : module 'tutor/forms/location_button'  :
        selector  : 'remotely_button'
        text      : 'Удаленно'
      address_input       : module 'tutor/forms/input'  :
        selector    : 'address_input'
        placeholder : 'Cимоновский вал 12, кв 98'