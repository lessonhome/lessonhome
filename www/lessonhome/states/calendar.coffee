class @main
  forms : [{'tutor':['calendar']}]
  tree : -> module '$' :
    selector        : @exports()
    tags_selector   : @exports()
    choose_all      : module 'tutor/forms/checkbox'  :
      text        : 'выбрать все'
      selector    : 'small'
    from_time       : module 'tutor/forms/input' :
      selector    : 'calendar'
      placeholder : 'с'
      pattern     : '^\\d{2}:\\d{2}$' #required using some like: (dataObject 'checker').patterns.time
      errMessage  : 'Пожалуйста введите кол-во часов от 0 до 24'
      align : 'center'
      allowSymbolsPattern  : "[:0-9]"
    till_time       : module 'tutor/forms/input' :
      selector    : 'calendar'
      placeholder : 'до'
      align : 'center'
      pattern     : '^\\d{2}:\\d{2}$' #required using some like: (dataObject 'checker').patterns.time
      errMessage  : 'Пожалуйста введите кол-во часов от 0 до 24'
      allowSymbolsPattern  : "[:0-9]"
    add_time_button : module 'tutor/button' :
      selector    : 'filter_add_time'
      text        :     'Добавить<br>время'
    tag       : module '//selected_tag' :
      day   : ''
      from_time : ''
      to_time   : ''
      selector  : 'choose_course'
      close     : true
    tags : $form : tutor : 'calendar'
    save_button       : module 'tutor/button' :
      text      : 'Сохранить'
      selector  : 'edit_save'
    #TODO: make create module selected_tag if user input time and press button add_time_button
