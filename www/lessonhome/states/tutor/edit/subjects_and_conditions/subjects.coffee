@route = '/tutor/edit/subjects'

@struct = state 'tutor/template/template'

@struct.header.top_menu.items =
  'Описание'           : 'general'
  'Предметы и условия' : 'subjects'

@struct.header.top_menu.active_item = 'Предметы и условия'

@struct.sub_top_menu = state 'tutor/template/sub_top_menu'

@struct.sub_top_menu?.items =
  'Предметы'     : 'subjects'
  'Место'        : 'location'
  'Календарь'    : 'calendar'
  'Предпочтения' : 'preferences'

@struct.sub_top_menu.active_item = 'Предметы'


@left_menu_href = ['../profile', '../bids', '#', '#', '#', '#', '#']
for href,i in @left_menu_href
  @struct.left_menu.items[i].href = href

@struct.left_menu.setActive.call(@struct.left_menu,'Анкета')



@struct.content = module 'tutor/edit/subjects_and_conditions/subjects':
  subject : module 'tutor/template/forms/drop_down_list' :
    width : @struct.vars.input_width1

  sections : module 'tutor/template/forms/drop_down_list' :
    width : @struct.vars.input_width1

  destinations : module 'tutor/template/forms/drop_down_list' :
    width : @struct.vars.input_width1

  category_students : module 'tutor/template/forms/drop_down_list' :
    width : @struct.vars.input_width1

  location : module 'tutor/template/forms/drop_down_list' :
    width : '180px'

  location_add : module 'tutor/template/button' :
    text  : '+'

  price : module 'tutor/template/forms/drop_down_list' :
    width : '70px'

  add_location : module 'tutor/template/button' :
    text  : '+'
    type : 'add'


  pupils_number : module 'tutor/template/forms/drop_down_list' :
    width : '180px'

  bet : module 'tutor/template/forms/drop_down_list' :
    width : '120px'

  comments : module 'tutor/template/forms/textarea' :
    id     : 'comments'
    height : '82px'


  add_button : module 'tutor/template/button' :
    text  : '+ Добавить'
    type  : 'fixed'

  save_button : module 'tutor/template/button' :
    text  : 'Сохранить'
    type  : 'fixed'

