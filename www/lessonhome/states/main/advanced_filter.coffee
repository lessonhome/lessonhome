class @main
  tree : => @module '$' :
    subject : @state '../tutor/forms/drop_down_list_with_tags' :
      list: @module 'tutor/forms/drop_down_list:type1'  :
        selector        : 'list_course'
        placeholder     : 'Например физика'
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
        selector        : 'advanced_filter_form'
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
    course : @state '../tutor/forms/drop_down_list_with_tags' :
      list: @module 'tutor/forms/drop_down_list:type1'  :
        selector        : 'advanced_filter_form'
        placeholder     : 'Например ЕГЭ'
        value     : ''
      tags: ''
    group_lessons : @module 'tutor/forms/drop_down_list'  :
      selector        : 'advanced_filter_form'
      default_options     : {
        '0': {value: 'no', text: 'не проводятся'}
        '1': {value: '2-4', text: '2-4 ученика'}
        '2': {value: 'to8', text: 'до 8 учеников'}
        '3': {value: 'from10', text: 'от 10 учеников'}
      }
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
      default :
        left : 30
        right : 120
      left  : 30  #$urlform : mainFilter : 'price.left'
      right : 120  #$urlform : mainFilter : 'price.right'
      min : 30
      max : 120
      #type : 'default'
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
