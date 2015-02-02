class @main extends template '../fast_bid'
  route : '/fast_bid/fourth_step'
  model : 'main/application/4_step'
  title : "быстрое оформление заявки: четвёртый шаг"
  tree : ->
    content : module '$'
    ###
      tutor : module 'tutor/forms/location_button' :
        selector : 'search_bids'
        text   : 'У себя'
      student  : module 'tutor/forms/location_button' :
        selector : 'search_bids'
        text   : 'У ученика'
      web : module 'tutor/forms/location_button' :
        selector : 'search_bids'
        text   : 'Удалённо'
      location_hint : module 'tutor/hint' :
        selector : 'small'
        text : 'Одно нажатие кнопки мыши для выбора дня, и двойное нажатие, чтобы ввести точное время для этого дня.'
      your_address : module 'tutor/forms/drop_down_list'
      road_time_to : module 'tutor/forms/input'
      road_time_slider : module '//slider'
      calendar : module '//calendar' :
        calendar_hint : module 'tutor/hint' :
          selector : 'small'
          text : 'Одно нажатие кнопки мыши для выбора дня, и двойное нажатие, чтобы ввести точное время для этого дня.'
      select_all : module 'tutor/forms/checkbox' :
        selector : 'bid_form'
      time_entry_field : module '//time_entry_field' :
        input_from : module 'tutor/forms/input' :
          selector : 'edit_calendar'
        input_to : module 'tutor/forms/input' :
          selector : 'edit_calendar'
        text_input : module 'tutor/forms/input' :
          selector : 'edit_calendar'
      add_button : module 'tutor/button' :
        selector : 'add_smth'
        text : '+'
      lesson_duration : module 'tutor/forms/input'
      slider : module '//slider' :
        slider_hint : module 'tutor/hint' :
          selector : 'small'
          text : 'Одно нажатие кнопки мыши для выбора дня, и двойное нажатие, чтобы ввести точное время для этого дня.'
      lesson_duration_hint : module 'tutor/hint' :
        selector : 'small'
        text : 'Одно нажатие кнопки мыши для выбора дня, и двойное нажатие, чтобы ввести точное время для этого дня.'
    hint : 'Вы можете<br>отправить заявку<br>в любой момент!<br>Но чем подробнее вы<br>её заполните, тем<br>лучше мы сможем<br>подобрать Вам<br>подходящего<br>репетитора :)'
    hint_margin_top : '20'


###
  init : ->
    @parent.tree.filter_top.progress_bar.progress = 4
    @parent.tree.filter_top.footer.button_back.selector = 'active'
    @parent.tree.filter_top.footer.issue_bid.selector = 'active'
    @parent.tree.filter_top.footer.back_link = 'third_step'
    @parent.tree.filter_top.footer.next_link = 'fifth_step'