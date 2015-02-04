class @main
  tree : => module '$' :
    list_course     : module 'tutor/forms/drop_down_list'  :
      selector        : 'list_course'
      placeholder     : 'Например ЕГЭ'
    add_course      : module '../selected_tag'  :
      selector  : 'choose_course'
      text      : 'Олимпиада'
      close     : true
    price_of_lesson   : state './slider_main' :
      selector    : 'lesson_price'
      start       : 'center_text'
      end         : 'center_text'
      measurement : 'руб.'
      dash        : '-'
    list_pupil     : module 'tutor/forms/drop_down_list'  :
      selector        : 'list_course'
      placeholder     : 'Например студент'
    add_pupil      : module '../selected_tag'  :
      selector  : 'choose_course'
      text      : 'Старшая школа'
      close     : true
    calendar        : module './calendar' :
      choose_all      : module 'tutor/forms/checkbox':
        selector        : 'time'
      from_time     : module 'tutor/forms/input' :
        selector      : 'time'
      till_time     : module 'tutor/forms/input' :
        selector      : 'center_text'
      button_add    : module 'tutor/button' :
        selector      : 'add_time'
        text          : '+'
    time_spend_lesson   : state './slider_main' :
      selector    : 'lesson_time'
      start       : 'center_text'
      end         : 'center_text'
      measurement : 'мин'
      dash        : '-'
    female            : module 'gender_button' :
      selector          : 'female'
    male              : module 'gender_button' :
      selector          : 'male'
