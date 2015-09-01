class @main extends @template '../fast_bid'
  route : '/fast_bid/third_step'
  model : 'main/application/3_step'
  title : "быстрое оформление заявки: третий шаг"
  access : ['pupil','other']
  redirect : {
    'tutor' : 'tutor/profile'
  }
  forms : [{pupil:['newBid', 'isStatus'], account:['fast_bid_progress']}]
  tree : ->
    #progress : $form : account : 'fast_bid_progress'
    progress : 3
    style_button_back   : 'fast_bid_nav'
    href_button_back    : 'second_step'
    style_issue_bid     : 'fast_bid_issue'
    href_issue_bid      : 'fourth_step'
    style_button_next   : 'fast_bid_nav'
    href_button_next    : 'fourth_step'
    b_selector  : 'star'
    content : @module '$' :
      student : @module 'tutor/forms/checkbox'  :
        text      : 'Студент'
        selector  : 'small'
        value : $urlform : pupil : 'status.student'
      teacher : @module 'tutor/forms/checkbox'  :
        text      : 'Преподаватель школы'
        selector  : 'small'
        value : $urlform : pupil : 'status.school_teacher'

      professor : @module 'tutor/forms/checkbox'  :
        text      : 'Преподаватель ВУЗа'
        selector  : 'small'
        value : $urlform : pupil : 'status.high_school_teacher'
      native : @module 'tutor/forms/checkbox'  :
        text      : 'Носитель языка'
        selector  : 'small'
        value : $urlform : pupil : 'status.native_speaker'
      experience : @module 'tutor/forms/drop_down_list':
        selector  : 'fast_bid'
        self : false
        no_input : true
        default_options     : {
          '0': {value: 'no_matter', text: 'неважно'}
          '1': {value: '1-2years', text: '1-2 года'},
          '2': {value: '3-4years', text: '3-4 года'},
          '3': {value: 'more_than_4_years', text: 'более 4 лет'},
        }
        value : $urlform : pupil : 'experience' #newBid.subjects.0.requirements_for_tutor.experience'
      #status_hint : @module 'tutor/hint' :
      #  selector : 'small'
      #  text : 'Одно нажатие кнопки мыши для выбора дня, и двойное нажатие, чтобы ввести точное время для этого дня.'
      ###
      age_slider   : @state '../slider_main' :
        selector      : 'time_fast_bids'
        default :
          left : 15
          right : 110
      #start         : 'calendar'
        dash          : '-'
        measurement   : 'лет'
        min : 15
        max : 110
        left  : $form : pupil : 'newBid.subjects.0.requirements_for_tutor.age.0'
        right : $form : pupil : 'newBid.subjects.0.requirements_for_tutor.age.1'
        division_value : 1
        type : 'default'
      gender_data   : @state 'gender_data':
        selector        : 'choose_gender'
        selector_button : 'registration'
        value : $form : pupil : 'newBid.subjects.0.requirements_for_tutor.sex'
      ###
      gender_data : @module 'tutor/forms/drop_down_list':
        selector  : 'fast_bid'
        items : ['неважно','мужской','женский']
        slef : false
        no_input : true
        value : $urlform : pupil : 'gender'
      #gender_hint : @module 'tutor/hint' :
      #  selector : 'small'
      #  text : 'Одно нажатие кнопки мыши для выбора дня, и двойное нажатие, чтобы ввести точное время для этого дня.'
    #hint : 'Вы можете<br>отправить заявку<br>в любой момент!<br>Но чем подробнее вы<br>её заполните, тем<br>лучше мы сможем<br>подобрать Вам<br>подходящего<br>репетитора :)'
