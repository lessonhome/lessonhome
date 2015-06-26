class @main
  tree : => @module '$' :
    subject : @state '../tutor/forms/drop_down_list_with_tags' :
      list: @module 'tutor/forms/drop_down_list:type1'  :
        selector        : 'list_course'
        placeholder     : 'Например физика'
        value     : ''
      tags: ''
      value : $urlform : mainFilter : 'subject'

    student : @module 'tutor/forms/checkbox'  :
      text      : 'Студент'
      selector  : 'small'
      value : $urlform : mainFilter : 'tutor_status.student'
    school_teacher : @module 'tutor/forms/checkbox'  :
      text      : 'Преподаватель школы'
      selector  : 'small'
      value : $urlform : mainFilter : 'tutor_status.school_teacher'
    university_teacher: @module 'tutor/forms/checkbox'  :
      text      : 'Преподаватель ВУЗа'
      selector  : 'small'
      value : $urlform : mainFilter : 'tutor_status.university_teacher'
    private_teacher: @module 'tutor/forms/checkbox'  :
      text      : 'Частный преподаватель'
      selector  : 'small'
      value : $urlform : mainFilter : 'tutor_status.private_teacher'
    native_speaker: @module 'tutor/forms/checkbox'  :
      text      : 'Носитель языка'
      selector  : 'small'
      value : $urlform : mainFilter : 'tutor_status.native_speaker'
    pupil: @module 'tutor/forms/checkbox'  :
      text      : 'У себя'
      selector  : 'small'
      value : $urlform : mainFilter : 'place.pupil'
    tutor: @module 'tutor/forms/checkbox'  :
      text      : 'У репетитора'
      selector  : 'small'
      value : $urlform : mainFilter : 'place.tutor'
    remote: @module 'tutor/forms/checkbox'  :
      text      : 'Удалённо'
      selector  : 'small'
      value : $urlform : mainFilter : 'place.remote'
    area : @state '../tutor/forms/drop_down_list_with_tags' :
      list: @module 'tutor/forms/drop_down_list:type1'  :
        selector        : 'advanced_filter_form'
        placeholder     : 'Выберите район'
        value     : ''
      tags: ''
      value : $urlform : mainFilter : 'place.area'


    little_experience: @module 'tutor/forms/checkbox'  :
      text      : '1-2 года'
      selector  : 'small'
      value : $urlform : mainFilter : 'experience.little_experience'
    big_experience: @module 'tutor/forms/checkbox'  :
      text      : '3-4 года'
      selector  : 'small'
      value : $urlform : mainFilter : 'experience.big_experience'
    bigger_experience: @module 'tutor/forms/checkbox'  :
      text      : 'более 4 лет'
      selector  : 'small'
      value : $urlform : mainFilter : 'experience.bigger_experience'
    no_experience: @module 'tutor/forms/checkbox'  :
      text      : 'нет опыта'
      selector  : 'small'
    course : @state '../tutor/forms/drop_down_list_with_tags' :
      list: @module 'tutor/forms/drop_down_list:type1'  :
        selector        : 'advanced_filter_form'
        placeholder     : 'Например ЕГЭ'
        value     : ''
      tags: ''
      value : $urlform : mainFilter : 'course'
    group_lessons : @module 'tutor/forms/drop_down_list'  :
      selector        : 'advanced_filter_form'
      default_options     : {
        '0': {value: 'no', text: 'не проводятся'}
        '1': {value: '2-4', text: '2-4 ученика'}
        '2': {value: 'to8', text: 'до 8 учеников'}
        '3': {value: 'from10', text: 'от 10 учеников'}
      }
      value : $urlform : mainFilter : 'group_lessons'
    calendar        : @state '../calendar' :
      selector  : 'advance_filter'
      value     : @exports 'val_list_calendar'
    price   : @state './slider_main' :
      selector      : 'advanced_filter_price'
      default :
        left : 500
        right : 3500
      left  : $urlform : mainFilter : 'price.left'
      right : $urlform : mainFilter : 'price.right'
      min : 500
      max : 3500
      type : 'default'
      dash          : '-'
      measurement   : 'руб.'
      division_value : 250
      #start         : 'advanced_filter'
      #end           : @module 'tutor/forms/input' :
      #  selector  : 'advanced_filter'
      #  align     : 'center'

      #value         : @exports 'val_time_spend_lesson'


    time_spend_way   : @state './slider_main' :
      selector      : 'advanced_filter_price'
      right : $urlform : mainFilter : 'time_spend_way'
      min : 30
      max : 120
      type : 'right'
      dash          : 'до'
      measurement   : 'мин.'
      division_value : 18
    choose_gender   : @state 'gender_data':
      selector        : 'advanced_filter'
      selector_button : 'advance_filter'
      default   : 'male'
      value     : $urlform : mainFilter : 'gender'
    with_reviews      : @module 'tutor/forms/checkbox'  :
      text      : 'только с отзывами'
      selector  : 'small'
      value     : $urlform : mainFilter : 'with_reviews'
    with_verification : @module 'tutor/forms/checkbox'  :
      text      : 'только проверенные<br/>профили'
      selector  : 'small'
      value     : $urlform : mainFilter : 'with_verification'
