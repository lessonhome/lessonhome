class @main
  tree : -> module '$' :
    selector        : @exports()
    choose_all      : module 'tutor/forms/checkbox'  :
      text        : 'выбрать все'
      selector    : 'small'
    from_time       : module 'tutor/forms/input' :
      selector    : 'calendar'
      placeholder : 'с'
    till_time       : module 'tutor/forms/input' :
      selector    : 'calendar'
      placeholder : 'до'
    add_time_button : module 'tutor/button' :
      selector    : 'filter_add_time'
      text        :     'Добавить<br>время'
    tag : module 'selected_tag' :
      text      : 'пн: 12:00 - 16:00'
      selector  : 'choose_course'
      close     : true
    #TODO: make create module selected_tag if user input time and press button add_time_button