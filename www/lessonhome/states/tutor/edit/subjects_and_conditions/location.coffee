@route = '/tutor/edit/location'

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

@struct.sub_top_menu.active_item = 'Место'


@left_menu_href = ['../profile', '../bids', '#', '#', '#', '#', '#']
for href,i in @left_menu_href
  @struct.left_menu.items[i].href = href

@struct.left_menu.setActive.call(@struct.left_menu,'Анкета')



@struct.content = module 'tutor/edit/subjects_and_conditions/location' :
  location : module 'tutor/template/choice' :
    id : 'location'
    indent : '22px'
    choice_list : [
      module 'tutor/template/button' :
        text  : 'У себя'
        type  : 'fixed'

      module 'tutor/template/button' :
        text  : 'У ученика'
        type  : 'fixed'

      module 'tutor/template/button' :
        text  : 'Удалённо'
        type  : 'fixed'
    ]

  country : module 'tutor/template/forms/drop_down_list' :
    width : @struct.vars.input_width1

  city : module 'tutor/template/forms/drop_down_list' :
    width : @struct.vars.input_width1

  district : module 'tutor/template/forms/drop_down_list' :
    width : @struct.vars.input_width1

  nearest_metro : module 'tutor/template/forms/drop_down_list' :
    width : @struct.vars.input_width1

  street : module 'tutor/template/forms/drop_down_list' :
    width : @struct.vars.input_width1

  house : module 'tutor/template/forms/drop_down_list' :
    width : @struct.vars.input_width2

  building : module 'tutor/template/forms/drop_down_list' :
    width : @struct.vars.input_width2

  flat : module 'tutor/template/forms/drop_down_list' :
    width : @struct.vars.input_width2

  add_button : module 'tutor/template/button' :
    text  : '+ Добавить'
    type  : 'fixed'

  save_button : module 'tutor/template/button' :
    text  : 'Сохранить'
    type  : 'fixed'


