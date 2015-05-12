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
        tags      : ''
      time_spend_lesson   : state './slider_main' :
        selector      : 'lesson_time'
        start         : 'calendar'
        end           : module 'tutor/forms/input' :
          selector    : 'calendar'
          align : 'center'
        dash          : '-'
        measurement   : 'мин.'
        handle        : true
        value          :
          min : 45
          max : 180
      time_spend_way   : state './slider_main' :
        selector      : 'lesson_time'
        start         : 'calendar'
        measurement   : 'мин.'
        value         :
          min : 15
          max : 120
        handle        : false
      choose_gender   : state 'gender_data':
        selector        : 'advanced_filter'
        selector_button : 'advance_filter'
      with_reviews      : module 'tutor/forms/checkbox'  :
        text      : 'С отзывами'
        selector  : 'small'
      with_verification : module 'tutor/forms/checkbox'  :
        text      : 'Верифицированные'
        selector  : 'small'
