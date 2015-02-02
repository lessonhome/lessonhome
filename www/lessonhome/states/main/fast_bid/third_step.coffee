class @main extends template '../fast_bid'
  route : '/fast_bid/third_step'
  model : 'main/application/3_step'
  title : "быстрое оформление заявки: третий шаг"
  tree : ->
    content : module '$' :
      tutor : module 'tutor/forms/location_button' :
        selector : 'search_bids'
        text   : 'У себя'
      student  : module 'tutor/forms/location_button' :
        selector : 'search_bids'
        text   : 'У ученика'
      web : module 'tutor/forms/location_button' :
        selector : 'search_bids'
        text   : 'Удалённо'
      your_address : module 'tutor/forms/drop_down_list'
      road_time_to : module 'tutor/forms/input'
      road_time_slider : module '//slider'
      calendar : module '//calendar' :
        calendar_hint : module 'tutor/hint' :
          selector : 'small'
          text : 'Одно нажатие кнопки мыши для выбора дня, и двойное нажатие, чтобы ввести точное время для этого дня.'
      select_all : module 'tutor/forms/checkbox' :
        selector : 'bid_form'
      time_entry_field : module '//time_entry_field'
      add_button : module 'tutor/button' :
        selector : 'add_smth'
        text : '+'
      lesson_duration : module 'tutor/forms/input'
      slider : module '//slider' :
        slider_hint : module 'tutor/hint' :
          selector : 'small'
          text : 'Одно нажатие кнопки мыши для выбора дня, и двойное нажатие, чтобы ввести точное время для этого дня.'

  init : ->
    @parent.tree.filter_top.progress_bar.progress = 3
    @parent.tree.filter_top.footer.button_back.selector = 'active'
    @parent.tree.filter_top.footer.issue_bid.selector = 'active'
    @parent.tree.filter_top.footer.back_link = 'second_step'
    @parent.tree.filter_top.footer.next_link = 'fourth_step'