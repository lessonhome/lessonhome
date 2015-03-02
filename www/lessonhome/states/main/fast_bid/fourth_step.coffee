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
      age_slider   : state '../slider_main' :
        selector      : 'time_fast_bids'
        start         : 'time_spend_bids'
        start_text    : 'до'
        measurement   : 'мин.'
        handle        : false
      sex_man     : module 'gender_button' :
        selector  : 'fast_bids'
        text      : 'М'
      sex_woman   : module 'gender_button' :
        selector  : 'fast_bids'
        text      : 'Ж'

    hint : 'Расскажите нам<br>ещё немного о<br>Вашем идеальном<br>репетиторе'

  init : ->
    @parent.tree.filter_top.footer.button_next.selector = 'hidden'
    @parent.tree.filter_top.footer.issue_bid.finish = true
    @parent.tree.filter_top.footer.back_link = 'third_step'
    @parent.tree.filter_top.footer.next_link = false