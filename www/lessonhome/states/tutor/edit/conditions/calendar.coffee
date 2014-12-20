class @main extends template '../../../tutor'
  route : '/tutor/edit/calendar'
  model   : 'tutor/edit/description/calendar'
  title : "редактирование календарь"
  tree  : =>
    items : [
      module 'tutor/header/button' : {
        title : 'Описание'
        href  : '/tutor/edit/general'
      }
      module 'tutor/header/button' : {
        title : 'Условия'
        href  : '/tutor/edit/subjects'
      }
    ]
    sub_top_menu : state 'tutor/sub_top_menu' :
      items :
        'Предметы'     : 'subjects'
        'Место'        : 'location'
        'Календарь'    : 'calendar'
        'Предпочтения' : 'preferences'
      active_item : 'Календарь'

    content : module '$':
      time_entry_fields : [
        module '//time_entry_field' :
          input_from : module 'tutor/forms/input' :
            width : '65px'

          input_to : module 'tutor/forms/input' :
            width : '65px'

          text_input : module 'tutor/forms/input' :
            width : '210px'

        module '//time_entry_field' :
          input_from : module 'tutor/forms/input' :
            width : '65px'

          input_to : module 'tutor/forms/input' :
            width : '65px'

          text_input : module 'tutor/forms/input' :
            width : '210px'


        module '//time_entry_field' :
          input_from : module 'tutor/forms/input' :
            width : '65px'

          input_to : module 'tutor/forms/input' :
            width : '65px'

          text_input : module 'tutor/forms/input' :
            width : '210px'


      ]

      add_button : module 'tutor/button' :
        text  : '+'
        selector  : 'add'

  init : ->
    @parent.tree.left_menu.setActive 'Анкета'
    @parent.tree.left_menu.setLinks ['../profile', '../search_bids', '#', '#', '#', '#', '#']

