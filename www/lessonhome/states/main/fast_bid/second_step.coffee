class @main extends template '../fast_bid'
  route : '/fast_bid/second_step'
  model : 'main/application/2_step'
  title : "быстрое оформление заявки: второй шаг"
  access : ['pupil','other']
  forms : ['pupil', {account:['fast_bid_progress']}]
  redirect : {
    'tutor' : 'tutor/profile'
    'default' : 'main/fast_bid/first_step'
  }
  tree : ->
    progress : $form : account : 'fast_bid_progress'
    content : module '$' :
      pupil_status : module 'tutor/forms/drop_down_list':
        text: 'Ваш статус :'
        selector  : 'fast_bid'
        default_options     : {
          '0': {value: 'preschool_child', text: 'дошкольник'},
          '1': {value: 'student_junior_school', text: 'школьник - младшая школа'},
          '2': {value: 'student_high_school', text: 'школьник - средняя школа'},
          '3': {value: 'student_senior_school', text: 'школьник - старшая школа'},
          '4': {value: 'student', text: 'студент'},
          '5': {value: 'grown_up', text: 'взрослый'}
        }
        value : $form : pupil : 'status'
      course : module 'tutor/forms/drop_down_list':
        text: 'Курс :'
        selector  : 'fast_bid'
        value : $form : pupil : 'subjects_0_course'
      knowledge_level : module 'tutor/forms/drop_down_list':
        text: 'Уровень знаний :'
        selector  : 'fast_bid'
        default_options     : {
          '0': {value: 'low', text: 'низкий'},
          '1': {value: 'average', text: 'средний'},
          '2': {value: 'advanced', text: 'продвинутый'}
        }
        value : $form : pupil : 'subjects_0_knowledge_level'
      price_slider_bids   : state '../slider_main' :
        selector      : 'price_slider_bids'
        start         : 'calendar'
        start_text    : 'от'
        end         : module 'tutor/forms/input' :
          selector  : 'calendar'
          text2      : 'до'
          align : 'center'
        measurement   : 'руб.'
        handle        : true
        value         :
          min : 400
          max : 5000
          left  : $form : pupil : 'subjects_0_lesson_price_left'
          right : $form : pupil : 'subjects_0_lesson_price_right'
      price_hint : module 'tutor/hint' :
        selector : 'small'
        text : 'Одно нажатие кнопки мыши для выбора дня, и двойное нажатие, чтобы ввести точное время для этого дня.'
      goal : module 'tutor/forms/textarea':
        text: 'Опишите цель :'
        selector  : 'fast_bid'
        value : $form : pupil : 'subjects_0_goal'
    #hint : 'Вы можете<br>отправить заявку<br>в любой момент!<br>Но чем подробнее вы<br>её заполните, тем<br>лучше мы сможем<br>подобрать Вам<br>подходящего<br>репетитора :)'

  init : ->
    @parent.tree.filter_top.button_back.selector = 'fast_bid_nav'
    @parent.tree.filter_top.button_back.href     = 'first_step'
    @parent.tree.filter_top.issue_bid.selector   = 'fast_bid_issue'
    @parent.tree.filter_top.issue_bid.href       = 'fifth_step'
    @parent.tree.filter_top.button_next.selector = 'fast_bid_nav'
    @parent.tree.filter_top.button_next.href     = 'third_step'
