class @main
  tree : => module '$' :
      list_course     : module 'tutor/forms/drop_down_list'  :
        selector        : 'list_course'
        placeholder     : 'Например ЕГЭ'
      add_course      : module 'tutor/button'  :
        selector        : 'choose_course'
        text            : 'ЕГЭ'
      calendar        : module './calendar' :
        choose_all      : module 'tutor/forms/checkbox':
          selector        : 'time'
        from_time     : module 'tutor/forms/input' :
          selector      : 'center_text'
        till_time     : module 'tutor/forms/input' :
          selector      : 'center_text'
        button_add    : module 'tutor/button' :
          selector      : 'add_time'
          text          : '+'
      time_spend_lesson   : state './slider_main' :
        selector    : 'lesson_time'
        start       : 'center_text'
        end         : 'center_text'
        measurement : 'мин.'
        dash        : '-'
      time_spend_way   : state './slider_main' :
        selector    : 'lesson_time'
        start       : 'center_text'
        end         : 'center_text'
        measurement : 'мин.'
        dash        : '-'
      female            : module 'tutor/button' :
        selector          : 'female'
        text              : 'Ж'
      male              : module 'tutor/button' :
        selector          : 'male'
        text              : 'М'
      with_reviews      : module 'tutor/forms/checkbox':
        selector          : 'time'
      with_verification : module 'tutor/forms/checkbox':
        selector          : 'time'