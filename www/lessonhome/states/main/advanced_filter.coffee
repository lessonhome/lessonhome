class @main
  tree : => module '$' :
      list_course     : module 'tutor/forms/drop_down_list'  :
        selector        : 'list_course'
        placeholder     : 'Например ЕГЭ'
      add_course      : module '../selected_tag'  :
        selector  : 'choose_course'
        text      : 'ЕГЭ'
        close     : true
      calendar        : module './calendar' :
        selector    : 'advance_filter'
        choose_all  : module 'tutor/forms/checkbox'  :
          text        : 'выбрать все'
          selector  : 'small'
        from_time     : module 'tutor/forms/input' :
          selector  : 'calendar'
          text      : 'с'
        till_time     : module 'tutor/forms/input' :
          selector  : 'calendar'
          text      : 'до'
        button_add    : module 'button_add' :
          text      : '+'
      time_spend_lesson   : state './slider_main' :
        selector      : 'lesson_time'
        start         : 'time_spend'
        measurement   : 'мин.'
        selector_two  : 'advance_move'
      time_spend_way   : state './slider_main' :
        selector      : 'lesson_time'
        start         : 'time_spend'
        measurement   : 'мин.'
        selector_two  : 'advance_move'
      female            : module 'gender_button' :
        selector    : 'female'
      male              : module 'gender_button' :
        selector    : 'male'
      with_reviews      : module 'tutor/forms/checkbox'  :
        text      : 'С отзывами'
        selector  : 'small'

      with_verification : module 'tutor/forms/checkbox'  :
        text      : 'Верифицированные'
        selector  : 'small'
