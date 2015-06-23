class @main
  tree : => @module '$' :
    subject : @state '../tutor/forms/drop_down_list_with_tags' :
      list: @module 'tutor/forms/drop_down_list:type1'  :
        selector        : 'list_course'
        placeholder     : 'Например ЕГЭ'
        value     : ''
      tags: ''

    student : @module 'tutor/forms/checkbox'  :
      text      : 'Студент'
      selector  : 'small'
    school_teacher : @module 'tutor/forms/checkbox'  :
      text      : 'Преподаватель школы'
      selector  : 'small'
    university_teacher: @module 'tutor/forms/checkbox'  :
      text      : 'Преподаватель ВУЗа'
      selector  : 'small'
    private_teacher: @module 'tutor/forms/checkbox'  :
      text      : 'Частный преподаватель'
      selector  : 'small'
    native_speaker: @module 'tutor/forms/checkbox'  :
      text      : 'Носитель языка'
      selector  : 'small'

    pupil: @module 'tutor/forms/checkbox'  :
      text      : 'У себя'
      selector  : 'small'
    tutor: @module 'tutor/forms/checkbox'  :
      text      : 'У репетитора'
      selector  : 'small'
    remote: @module 'tutor/forms/checkbox'  :
      text      : 'Удалённо'
      selector  : 'small'

    area : @state '../tutor/forms/drop_down_list_with_tags' :
      list: @module 'tutor/forms/drop_down_list:type1'  :
        selector        : 'filter_area'
        placeholder     : 'Выберите район'
        value     : ''
      tags: ''

    little_experience: @module 'tutor/forms/checkbox'  :
      text      : '1-2 года'
      selector  : 'small'
    big_experience: @module 'tutor/forms/checkbox'  :
      text      : '3-4 года'
      selector  : 'small'
    bigger_experience: @module 'tutor/forms/checkbox'  :
      text      : 'более 4 лет'
      selector  : 'small'
    no_experience: @module 'tutor/forms/checkbox'  :
      text      : 'нет опыта'
      selector  : 'small'



    calendar        : @state '../calendar' :
          selector  : 'advance_filter'
          value     : @exports 'val_list_calendar'
    price   : @state './slider_main' :
      selector      : 'price'
      start         : 'calendar'
      end           : @module 'tutor/forms/input' :
        selector  : 'calendar'
        align     : 'center'
      dash          : '-'
      measurement   : 'руб.'
      handle        : true
      value         : @exports 'val_time_spend_lesson'
    time_spend_way   : @state './slider_main' :
      selector      : 'lesson_time'
      start         : 'calendar'
      measurement   : 'мин.'
      handle        : false
      value     : @exports 'val_time_spend_way'
    choose_gender   : @state 'gender_data':
      selector        : 'advanced_filter'
      selector_button : 'advance_filter'
      value     : @exports 'val_choose_gender'
    with_reviews      : @module 'tutor/forms/checkbox'  :
      text      : 'только с отзывами'
      selector  : 'small'
      value     : @exports 'val_with_reviews'
    with_verification : @module 'tutor/forms/checkbox'  :
      text      : 'только проверенные<br/>профили'
      selector  : 'small'
      value     : @exports 'val_with_verification'
