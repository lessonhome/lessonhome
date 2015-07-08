class @main extends @template '../fast_bid'
  route : '/fast_bid/second_step'
  model : 'main/application/2_step'
  title : "быстрое оформление заявки: второй шаг"
  access : ['pupil','other']
  forms : ['pupil', {account:['fast_bid_progress']}]
  redirect : {
    'tutor' : 'tutor/profile'
  }
  tree : ->
    #progress : $form : account : 'fast_bid_progress'
    progress : 2
    content : @module '$' :
      #knowledge_level : @module 'tutor/forms/drop_down_list':
      #  text: 'Уровень знаний :'
      #  selector  : 'fast_bid'
      #  default_options     : {
      #    '0': {value: 'low', text: 'низкий'},
      #    '1': {value: 'average', text: 'средний'},
      #    '2': {value: 'advanced', text: 'продвинутый'}
      #  }
      #  value : $form : pupil : 'newBid.subjects.0.knowledge'
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

      calendar        : @module 'new_calendar' :
        selector    : 'bids'
      #calendar_hint : @module 'tutor/hint' :
      #  selector : 'small'
      #  text : 'Одно нажатие кнопки мыши для выбора дня, и двойное нажатие, чтобы ввести точное время для этого дня.'

      #price_slider_bids   : @state '../slider_main' :
        #  selector      : 'price_slider_bids'
        #  #start         : 'calendar'
        #  default :
        #    left : 500
        #    right : 5000
        #  #start_text    : 'от'
        #  type : 'default'
        #  dash          : '-'
        #  measurement   : 'руб.'
        #  #handle        : true
        #  min : 400
        #  max : 5000
        #  left  : $form : pupil : 'lesson_price.left'
        #  right : $form : pupil : 'lesson_price.right'
        #  division_value : 500
        #price_hint : @module 'tutor/hint' :
        #  selector : 'small'
        #  text : 'Одно нажатие кнопки мыши для выбора дня, и двойное нажатие, чтобы ввести точное время для этого дня.'

      time_spend_lesson   : @state '../slider_main' :
        selector      : 'time_fast_bids'
        default :
          left : 45
          right : 180
      #start         : 'calendar'
        dash          : '-'
        measurement   : 'мин.'
        min : 45
        max : 180
        left  : $form : pupil : 'newBid.subjects.0.lesson_duration.0'
        right : $form : pupil : 'newBid.subjects.0.lesson_duration.1'
        division_value : 15
        type : 'default'


      price_500: @module 'tutor/forms/checkbox'  :
        text      : 'до 500'
        selector  : 'small'
        #value : $urlform : mainFilter : 'place.pupil'
      price_500_1000: @module 'tutor/forms/checkbox'  :
        text      : 'от 500 до 1000'
        selector  : 'small'
        #value : $urlform : mainFilter : 'place.tutor'
      price_1000_2000: @module 'tutor/forms/checkbox'  :
        text      : 'от 1000 до 2000'
        selector  : 'small'
        #value : $urlform : mainFilter : 'place.remote'
      price_2000: @module 'tutor/forms/checkbox'  :
        text      : 'от 2000'
        selector  : 'small'
        #value : $urlform : mainFilter : 'place.remote'
      #lesson_time_hint : @module 'tutor/hint' :
      #  selector : 'small'
      #  text : 'Одно нажатие кнопки мыши для выбора дня, и двойное нажатие, чтобы ввести точное время для этого дня.'
      #goal : @module 'tutor/forms/textarea':
      #  text: 'Опишите цель :'
      #  selector  : 'fast_bid'
      #  value : $form : pupil : 'newBid.subjects.0.goal'
    #hint : 'Вы можете<br>отправить заявку<br>в любой момент!<br>Но чем подробнее вы<br>её заполните, тем<br>лучше мы сможем<br>подобрать Вам<br>подходящего<br>репетитора :)'

  init : ->
    @parent.tree.filter_top.button_back.selector = 'fast_bid_nav'
    @parent.tree.filter_top.button_back.href     = 'first_step'
    @parent.tree.filter_top.issue_bid.selector   = 'fast_bid_issue'
    @parent.tree.filter_top.issue_bid.href       = 'fifth_step'
    @parent.tree.filter_top.button_next.selector = 'fast_bid_nav'
    @parent.tree.filter_top.button_next.href     = 'third_step'
