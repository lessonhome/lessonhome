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
          selector   : 'calendar'
          placeholder: 'с'
        till_time     : module 'tutor/forms/input' :
          selector   : 'calendar'
          text       : '-'
          placeholder: 'до'
        add_time_button : module 'tutor/button' :
          selector: 'filter_add_time'
          text:     'Добавить<br>время'
        new_tag : module 'selected_tag' :
          text: 'Текст'
          selector: 'advanced_filter_calendar'

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
