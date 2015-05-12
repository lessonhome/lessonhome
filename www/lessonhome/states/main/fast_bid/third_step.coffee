class @main extends template '../fast_bid'
  route : '/fast_bid/third_step'
  model : 'main/application/3_step'
  title : "быстрое оформление заявки: третий шаг"
  access : ['pupil','other']
  redirect : {
    'tutor' : 'tutor/profile'
    'default' : 'main/fast_bid/first_step'
  }
  forms : [{pupil:['first_subject', 'isPlace'], person:['location']}]
  tree : ->
    progress : 3
    content : module '$' :
      tutor : module 'tutor/forms/location_button' :
        selector : 'place_learn'
        text   : 'у себя'
        $form : pupil : 'isPlace.tutor'
      student  : module 'tutor/forms/location_button' :
        selector : 'place_learn'
        text   : 'у ученика'
        $form : pupil : 'isPlace.pupil'
      web : module 'tutor/forms/location_button' :
        selector : 'place_learn'
        text   : 'удалённо'
        $form : pupil : 'isPlace.other'
      location_hint : module 'tutor/hint' :
        selector : 'small'
        text : 'Одно нажатие кнопки мыши для выбора дня, и двойное нажатие, чтобы ввести точное время для этого дня.'
      your_address : module 'tutor/forms/drop_down_list':
        text: 'Ваш адрес :'
        selector  : 'fast_bid'
        $form : person : 'location.full_address'
      time_spend_way   : state '../slider_main' :
        selector      : 'way_fast_bids'
        start         : 'calendar'
        start_text    : 'до'
        measurement   : 'мин.'
        handle        : false
        value         :
          min : 15
          max : 120
          left :  $form : pupil : 'first_subject.road_time'
      way_time_hint : module 'tutor/hint' :
        selector : 'small'
        text : 'Одно нажатие кнопки мыши для выбора дня, и двойное нажатие, чтобы ввести точное время для этого дня.'
      calendar        : state 'calendar' :
        selector    : 'advance_filter'
        tags_selector : 'fast_bid'
        tags : $form : pupil : 'first_subject.calendar'
      calendar_hint : module 'tutor/hint' :
        selector : 'small'
        text : 'Одно нажатие кнопки мыши для выбора дня, и двойное нажатие, чтобы ввести точное время для этого дня.'
      time_spend_lesson   : state '../slider_main' :
        selector      : 'time_fast_bids'
        start         : 'calendar'
        dash          : '-'
        end         : module 'tutor/forms/input' :
          selector  : 'calendar'
          align : 'center'
        measurement   : 'мин.'
        handle        : true
        value         :
          min : 45
          max : 180
          left  : $form : pupil : 'first_subject.lesson_duration.0'
          right : $form : pupil : 'first_subject.lesson_duration.1'
      lesson_time_hint : module 'tutor/hint' :
        selector : 'small'
        text : 'Одно нажатие кнопки мыши для выбора дня, и двойное нажатие, чтобы ввести точное время для этого дня.'
    #hint : 'Вы можете<br>отправить заявку<br>в любой момент!<br>Но чем подробнее вы<br>её заполните, тем<br>лучше мы сможем<br>подобрать Вам<br>подходящего<br>репетитора :)'
  init : ->
    @parent.tree.filter_top.button_back.selector = 'fast_bid_nav'
    @parent.tree.filter_top.button_back.href     = 'second_step'
    @parent.tree.filter_top.issue_bid.selector   = 'fast_bid_issue'
    @parent.tree.filter_top.issue_bid.href       = 'fifth_step'
    @parent.tree.filter_top.button_next.selector = 'fast_bid_nav'
    @parent.tree.filter_top.button_next.href     = 'fourth_step'
