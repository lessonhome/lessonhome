@route = '/tutor/edit/calendar'

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

@struct.sub_top_menu?.active_item = 'Календарь'



@left_menu_href = ['../profile', '../bids', '#', '#', '#', '#', '#']
for href,i in @left_menu_href
  @struct.left_menu.items[i].href = href

@struct.left_menu.setActive.call(@struct.left_menu,'Анкета')


@struct.content = module 'tutor/edit/subjects_and_conditions/calendar':
  time_entry_fields : [
    module '//time_entry_field' :
      input_from : module 'tutor/template/forms/input' :
        width : '65px'

      input_to : module 'tutor/template/forms/input' :
        width : '65px'

      text_input : module 'tutor/template/forms/input' :
        width : '210px'

    module '//time_entry_field' :
      input_from : module 'tutor/template/forms/input' :
        width : '65px'

      input_to : module 'tutor/template/forms/input' :
        width : '65px'

      text_input : module 'tutor/template/forms/input' :
        width : '210px'


    module '//time_entry_field' :
      input_from : module 'tutor/template/forms/input' :
        width : '65px'

      input_to : module 'tutor/template/forms/input' :
        width : '65px'

      text_input : module 'tutor/template/forms/input' :
        width : '210px'


  ]


  add_button : module 'tutor/template/button' :
    text  : '+'
    type  : 'add'