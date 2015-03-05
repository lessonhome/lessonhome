class @main extends template '../../edit'
  route : '/tutor/edit/calendar'
  model   : 'tutor/edit/conditions/calendar'
  title : "редактирование календарь"
  tags : -> 'edit: conditions'
  tree  : =>
    menu_condition  : 'edit: conditions'
    items :
      'Предметы'     : 'subjects'
      'Место'        : 'location'
      'Календарь'    : 'calendar'
      'Предпочтения' : 'preferences'
    active_item : 'Календарь'
    tutor_edit  : module '$':
      calendar : module 'main/calendar' :
        calendar_hint : module 'tutor/hint' :
          selector : 'small'
          text : 'Одно нажатие кнопки мыши для выбора дня, и двойное нажатие, чтобы ввести точное время для этого дня.'
      time_entry_hint : module 'tutor/hint' :
        selector : 'small'
      time_entry_fields : [
        module '//time_entry_field' :
          input_from : module 'tutor/forms/input' :
            selector : 'edit_calendar'
          input_to : module 'tutor/forms/input' :
            selector : 'edit_calendar'
          text_input : module 'tutor/forms/input' :
            selector : 'edit_calendar'

        module '//time_entry_field' :
          input_from : module 'tutor/forms/input' :
            selector : 'edit_calendar'
          input_to : module 'tutor/forms/input' :
            selector : 'edit_calendar'
          text_input : module 'tutor/forms/input' :
            selector : 'edit_calendar'

        module '//time_entry_field' :
          input_from : module 'tutor/forms/input' :
            selector : 'edit_calendar'
          input_to : module 'tutor/forms/input' :
            selector : 'edit_calendar'
          text_input : module 'tutor/forms/input' :
            selector : 'edit_calendar'


      ]

      add_entry_field : module 'tutor/button' :
        text     : '+'
        selector : 'add_smth'
