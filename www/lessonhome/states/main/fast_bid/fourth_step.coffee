class @main extends @template '../fast_bid'
  route : '/fast_bid/fourth_step'
  model : 'main/application/4_step'
  title : "быстрое оформление заявки: четвёртый шаг"
  access : ['pupil','other']
  redirect : {
    tutor : 'tutor/profile'
  }
  forms : [{pupil:['newBid', 'isStatus'], account:['fast_bid_progress']}]
  tree : ->
    progress : $form : account : 'fast_bid_progress'
    content : @module '$' :
      student : @module 'tutor/forms/location_button' :
        selector : 'status_button'
        text : 'Студент'
        $form : pupil : 'isStatus.student'
      teacher : @module 'tutor/forms/location_button' :
        selector : 'status_button'
        text : 'Преподаватель школы'
        $form : pupil : 'isStatus.school_teacher'
      professor : @module 'tutor/forms/location_button' :
        selector : 'status_button'
        text : 'Преподаватель ВУЗа'
        $form : pupil : 'isStatus.high_school_teacher'
      native : @module 'tutor/forms/location_button' :
        selector : 'status_button'
        text : 'Носитель языка'
        $form : pupil : 'isStatus.native_speaker'
      experience : @module 'tutor/forms/drop_down_list':
        text      : 'Опыт:'
        selector  : 'fast_bid'
        default_options     : {
          '0': {value: '1-2years', text: '1-2 года'},
          '1': {value: '3-4years', text: '3-4 года'},
          '2': {value: 'more_than_4_years', text: 'более 4 лет'},
          '3': {value: 'no_matter', text: 'неважно'}
        }
        $form : pupil : 'newBid.subjects.0.requirements_for_tutor.experience'
      status_hint : @module 'tutor/hint' :
        selector : 'small'
        text : 'Одно нажатие кнопки мыши для выбора дня, и двойное нажатие, чтобы ввести точное время для этого дня.'
      age_slider   : @state '../slider_main' :
        selector      : 'time_fast_bids'
        default :
          left : 18
          right : 90
        #start         : 'calendar'
        start_text    : 'от'
        min : 18
        max : 90
        left  : $form : pupil : 'newBid.subjects.0.requirements_for_tutor.age.0'
        right : $form : pupil : 'newBid.subjects.0.requirements_for_tutor.age.1'
        division_value : 8
      gender_data   : @state 'gender_data':
        selector        : 'choose_gender'
        selector_button : 'registration'
        value : $form : pupil : 'newBid.subjects.0.requirements_for_tutor.sex'
      gender_hint : @module 'tutor/hint' :
        selector : 'small'
        text : 'Одно нажатие кнопки мыши для выбора дня, и двойное нажатие, чтобы ввести точное время для этого дня.'

    #hint : 'Расскажите нам<br>ещё немного о<br>Вашем идеальном<br>репетиторе'

  init : ->
    @parent.tree.filter_top.button_back.selector = 'fast_bid_nav'
    @parent.tree.filter_top.button_back.href     = 'third_step'
    @parent.tree.filter_top.issue_bid.selector   = 'fast_bid_issue'
    @parent.tree.filter_top.issue_bid.href       = 'fifth_step'
    @parent.tree.filter_top.button_next.selector = 'fast_bid_nav visibility'
    @parent.tree.filter_top.button_next.href     = false
