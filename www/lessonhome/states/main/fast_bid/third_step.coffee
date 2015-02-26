class @main extends template '../fast_bid'
  route : '/fast_bid/third_step'
  model : 'main/application/3_step'
  title : "быстрое оформление заявки: третий шаг"
  tree : ->
    progress : 3
    content : module '$' :
      tutor : module 'tutor/forms/location_button' :
        selector : 'search_bids'
        text   : 'у себя'
      student  : module 'tutor/forms/location_button' :
        selector : 'search_bids'
        text   : 'у ученика'
      web : module 'tutor/forms/location_button' :
        selector : 'search_bids'
        text   : 'удалённо'
      location_hint : module 'tutor/hint' :
        selector : 'small'
        text : 'Одно нажатие кнопки мыши для выбора дня, и двойное нажатие, чтобы ввести точное время для этого дня.'
      your_address : module 'tutor/forms/drop_down_list':
        text: 'Ваш адрес :'
        selector  : 'fast_bid'
      time_spend_way   : state '../slider_main' :
        selector      : 'way_fast_bids'
        start         : 'time_spend_bids'
        start_text    : 'до'
        measurement   : 'мин.'
        handle        : false
      calendar        : module 'main/calendar' :
        selector    : 'fast_bids'
        choose_all  : module 'tutor/forms/checkbox'  :
          text        : 'выбрать все'
          selector  : 'small'
        from_time     : module 'tutor/forms/input' :
          selector  : 'calendar_fast_bids'
          text      : 'с'
        till_time     : module 'tutor/forms/input' :
          selector  : 'calendar_fast_bids'
          text      : 'до'
        button_add    : module 'button_add' :
          text      : '+'

      time_spend_lesson   : state '../slider_main' :
        selector      : 'time_fast_bids'
        start         : 'time_spend_bids'
        start_text    : 'до'
        measurement   : 'мин.'
        handle        : false
    hint : 'Вы можете<br>отправить заявку<br>в любой момент!<br>Но чем подробнее вы<br>её заполните, тем<br>лучше мы сможем<br>подобрать Вам<br>подходящего<br>репетитора :)'
  init : ->
    @parent.tree.filter_top.footer.back_link = 'second_step'
    @parent.tree.filter_top.footer.next_link = 'fourth_step'