class @main
  tree : => module '$' :
      list_course     : module 'tutor/forms/drop_down_list'  :
        selector        : 'list_course'
        placeholder     : 'Например ЕГЭ'
      add_course      : module '../selected_tag'  :
        selector  : 'choose_course'
        text      : 'ЕГЭ'
        close     : true
      calendar        : state '../calendar' :
        selector  : 'advance_filter'
      time_spend_lesson   : state './slider_main' :
        selector      : 'lesson_time'
        start         : 'time_spend'
        end           : module 'tutor/forms/input' :
          selector    : 'time_spend'
        dash          : '-'
        measurement   : 'мин.'
        handle        : true
      time_spend_way   : state './slider_main' :
        selector      : 'lesson_time'
        start         : 'time_spend'
        measurement   : 'мин.'
        handle        : false
      female            : module 'gender_button' :
        selector    : 'advance_filter'
        text        : 'Ж'
      male              : module 'gender_button' :
        selector    : 'advance_filter'
        text        : 'М'
      with_reviews      : module 'tutor/forms/checkbox'  :
        text      : 'С отзывами'
        selector  : 'small'

      with_verification : module 'tutor/forms/checkbox'  :
        text      : 'Верифицированные'
        selector  : 'small'
