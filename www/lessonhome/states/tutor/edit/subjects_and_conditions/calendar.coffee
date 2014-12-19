
class @main extends template 'tutor/template/template'
  route : '/tutor/edit/calendar'
  model   : 'tutor/edit/description/calendar'
  title : "редактирование календарь"
  tree  : ->
    sub_top_menu : state 'tutor/template/sub_top_menu' :
      items :
        'Предметы'     : 'subjects'
        'Место'        : 'location'
        'Календарь'    : 'calendar'
        'Предпочтения' : 'preferences'
      active_item : 'Календарь'

    content : module 'tutor/edit/conditions/calendar':
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
        selector  : 'add'

  init : ->
    @parent.setTopMenu 'Условия', {
      'Описание': 'general'
      'Условия': 'subjects'
    }

    @parent.tree.left_menu.setActive 'Анкета'
    @parent.tree.left_menu.setLinks ['../profile', '../bids', '#', '#', '#', '#', '#']

