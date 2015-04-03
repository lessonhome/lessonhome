class @main extends template '../fast_bid'
  route : '/fast_bid/fourth_step'
  model : 'main/application/4_step'
  title : "быстрое оформление заявки: четвёртый шаг"
  tree : ->
    progress : 4
    content : module '$' :
      student : module 'tutor/forms/location_button' :
        selector : 'status_button'
        text : 'Студент'
      teacher : module 'tutor/forms/location_button' :
        selector : 'status_button active'
        text : 'Преподаватель школы'
      professor : module 'tutor/forms/location_button' :
        selector : 'status_button'
        text : 'Преподаватель ВУЗа'
      native : module 'tutor/forms/location_button' :
        selector : 'status_button'
        text : 'Носитель языка'
      experience : module 'tutor/forms/drop_down_list':
        text      : 'Опыт:'
        selector  : 'fast_bid'
        default_options     : {
          '0': {value: '1-2years', text: '1-2 года'},
          '1': {value: '3-4years', text: '3-4 года'},
          '2': {value: 'more_than_4_years', text: 'более 4 лет'},
          '3': {value: 'no_matter', text: 'неважно'}
        }
      status_hint : module 'tutor/hint' :
        selector : 'small'
        text : 'Одно нажатие кнопки мыши для выбора дня, и двойное нажатие, чтобы ввести точное время для этого дня.'
      age_slider   : state '../slider_main' :
        selector      : 'time_fast_bids'
        start         : 'calendar'
        start_text    : 'от'
        end         : module 'tutor/forms/input' :
          selector  : 'calendar'
          text2      : 'до'
          align : 'center'
        handle        : true
        min           : 18
        max           : 90
      gender_data   : state 'gender_data':
        selector        : 'choose_gender'
        selector_button : 'registration'
      gender_hint : module 'tutor/hint' :
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
