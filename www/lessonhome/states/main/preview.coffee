class @main extends template '../main'
  tree : =>
    filter_top : @exports()
    content : module '$' :
      advanced_filter : module '$/advanced_filter'  :
        list_course     : module 'tutor/forms/drop_down_list'  :
          selector        : 'list_course'
          placeholder     : 'Например ЕГЭ'
        add_course      : module 'tutor/button'  :
          selector        : 'choose_course'
          text            : 'ЕГЭ'
        calendar        : module '$/calendar' :
          choose_all      : module 'tutor/forms/checkbox':
            selector        : 'time'
          from_time     : module 'tutor/forms/input' :
            selector      : 'time'
          till_time     : module 'tutor/forms/input' :
            selector      : 'time'
          button_add    : module 'tutor/button' :
            selector      : 'add_time'
            plus          : '+'
        time_spend      : module '$/time_spend' :
          lesson_start    : module 'tutor/forms/input' :
            selector        : 'lesson_start'
          lesson_end      : module 'tutor/forms/input' :
            selector        : 'lesson_end'
          move_time       : module '../slider'
        time_spend      : module '$/time_spend' :
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






      content : module '//content' :                # center
        sort            : module '//sort'
        choose_tutors    : module '//choose_tutors'
        tutors          : module '//tutors'