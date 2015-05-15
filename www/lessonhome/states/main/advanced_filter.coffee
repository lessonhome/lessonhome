class @main
  tree : => module '$' :
      list_course     : module 'tutor/forms/drop_down_list'  :
        selector        : 'list_course'
        placeholder     : 'Например ЕГЭ'
        value     : @exports 'val_list_course'
      add_course      : @exports 'val_add_course'
      #add_course      : module '../selected_tag'  :
      #  selector  : 'choose_course'
      #  close     : true
      #  value     : @exports 'val_list_course'
      calendar        : state '../calendar' :
        selector  : 'advance_filter'
        value     : @exports 'val_list_calendar'
      time_spend_lesson   : state './slider_main' :
        selector      : 'lesson_time'
        start         : 'calendar'
        end           : module 'tutor/forms/input' :
          selector  : 'calendar'
          align     : 'center'
        dash          : '-'
        measurement   : 'мин.'
        handle        : true
        value         : @exports 'val_time_spend_lesson'
      time_spend_way   : state './slider_main' :
        selector      : 'lesson_time'
        start         : 'calendar'
        measurement   : 'мин.'
        handle        : false
        value     : @exports 'val_time_spend_way'
      choose_gender   : state 'gender_data':
        selector        : 'advanced_filter'
        selector_button : 'advance_filter'
        value     : @exports 'val_choose_gender'
      with_reviews      : module 'tutor/forms/checkbox'  :
        text      : 'С отзывами'
        selector  : 'small'
        value     : @exports 'val_with_reviews'
      with_verification : module 'tutor/forms/checkbox'  :
        text      : 'Верифицированные'
        selector  : 'small'
        value     : @exports 'val_with_verification'
