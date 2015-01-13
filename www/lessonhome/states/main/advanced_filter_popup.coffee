class @main
  tree : => module '$' :
    list_course     : module 'tutor/forms/drop_down_list'  :
      selector        : 'list_course'
      placeholder     : 'Например ЕГЭ'
    add_course      : module 'tutor/button'  :
      selector        : 'choose_course'
      text            : 'Олимпиада'
    price_of_lesson   : state './slider_main' :
      selector    : 'lesson_price'
      start       : 'price_start'
      end         : 'price_end'
      measurement : 'руб.'
      dash        : '-'
    list_pupil     : module 'tutor/forms/drop_down_list'  :
      selector        : 'list_course'
      placeholder     : 'Например студент'
    add_pupil      : module 'tutor/button'  :
      selector        : 'choose_course'
      text            : 'Старшая школа'
    calendar        : module './calendar' :
      choose_all      : module 'tutor/forms/checkbox':
        selector        : 'time'
      from_time     : module 'tutor/forms/input' :
        selector      : 'time'
      till_time     : module 'tutor/forms/input' :
        selector      : 'time'
      button_add    : module 'tutor/button' :
        selector      : 'add_time'
        text          : '+'
    time_spend_lesson   : state './slider_main' :
      selector    : 'lesson_time'
      start       : 'lesson_start'
      end         : 'lesson_end'
      measurement : 'мин'
      dash        : '-'
    female            : module 'tutor/button' :
      selector          : 'female'
      text              : 'Ж'
    male              : module 'tutor/button' :
      selector          : 'male'
      text              : 'М'
