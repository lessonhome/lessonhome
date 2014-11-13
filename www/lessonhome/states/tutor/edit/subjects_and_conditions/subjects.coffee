@route = '/tutor/edit/subjects'

@struct = state 'tutor/template/template'

@struct.edit_line.top_menu.items =
  'Описание'           : '#'
  'Предметы и условия' : '#'

@struct.edit_line.top_menu.active_item = 'Предметы и условия'

@struct.sub_top_menu = state 'tutor/template/sub_top_menu'

@struct.sub_top_menu?.items =
  'Предметы'     : 'subjects'
  'Место'        : 'location'
  'Календарь'    : 'calendar'
  'Предпочтения' : 'preferences'

@struct.sub_top_menu?.active_item = 'Предметы'

@struct.content = module 'tutor/edit/subjects_and_conditions/subjects':
  subject : module 'tutor/template/forms/drop_down_list' :
    width : '335px'

  sections : module 'tutor/template/forms/drop_down_list' :
    width : '335px'

  destinations : module 'tutor/template/forms/drop_down_list' :
    width : '335px'

  category_students : module 'tutor/template/forms/drop_down_list' :
    width : '335px'

  location : module 'tutor/template/forms/drop_down_list' :
    width : '150px'

  location_add : module 'tutor/template/button' :
    text  : '+'

  price : module 'tutor/template/forms/drop_down_list' :
    width : '85px'

  add_location : module 'tutor/template/button' :
    text  : '+'
    type : 'streamlined'

  group_lessons : [
    module 'tutor/template/forms/drop_down_list' :
      width : '150px'

    module 'tutor/template/forms/drop_down_list' :
      width : '120px'
  ]

  comments : module 'tutor/template/forms/textarea' :
    id     : 'comments'
    width  : '335px'
    height : '82px'


  add_button : module 'tutor/template/button' :
    text  : '+ Добавить'
    type  : 'fixed'

  save_button : module 'tutor/template/button' :
    text  : 'Сохранить'
    type  : 'fixed'

