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
          selector      : 'time'
        till_time     : module 'tutor/forms/input' :
          selector      : 'time'
        button_add    : module 'tutor/button' :
          selector      : 'add_time'
          text          : '+'
      time_spend_lesson      : module '//time_spend' :
        lesson_start    : module 'tutor/forms/input' :
          selector        : 'lesson_start'
        lesson_end      : module 'tutor/forms/input' :
          selector        : 'lesson_end'
        move_time       : module '../slider'
      time_spend_way      : module '//time_spend' :
        lesson_start    : module 'tutor/forms/input' :
          selector        : 'lesson_start'
        lesson_end      : module 'tutor/forms/input' :
          selector        : 'lesson_end'
        move_time       : module '../slider'
      female            : module 'tutor/button' :
        selector          : 'female'
        text              : 'Ж'
      male              : module 'tutor/button' :
        selector          : 'male'
        text              : 'М'
      with_reviews      : module 'tutor/forms/checkbox':
        selector          : 'time'
      with_reviews      : module 'tutor/forms/checkbox':
        selector          : 'time'