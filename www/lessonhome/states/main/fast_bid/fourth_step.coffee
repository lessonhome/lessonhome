class @main extends template '../fast_bid'
  route : '/fast_bid/fourth_step'
  model : 'main/application/4_step'
  title : "быстрое оформление заявки: четвёртый шаг"
  tree : ->
    content : module '$' :
      status_student : module 'tutor/forms/status_button' :
        selector : 'inactive'
        text : 'Студент'
      status_teacher : module 'tutor/forms/status_button' :
        selector : 'active'
        text : 'Преподаватель'
      status_phd : module 'tutor/forms/status_button' :
        selector : 'inactive'
        text : 'Кандидат наук'
      experience : module 'tutor/forms/drop_down_list':
        text: 'опыт'
      age_slider   : state '../slider_main' :
        selector      : 'time_fast_bids'
        start         : 'time_spend_bids'
        start_text    : 'до'
        measurement   : 'мин.'
        selector_two  : 'fast_bids_spend'
      sex_man     : module 'tutor/forms/sex_button' :
        selector : 'man'
      sex_woman   : module 'tutor/forms/sex_button' :
        selector : 'woman'

      hint : 'Расскажите нам<br>ещё немного о<br>Вашем идеальном<br>репетиторе'

  init : ->
    @parent.tree.filter_top.progress_bar.progress = 4
    @parent.tree.filter_top.footer.button_next.selector = 'hidden'
    @parent.tree.filter_top.footer.issue_bid.finish = true
    @parent.tree.filter_top.footer.back_link = 'third_step'
    @parent.tree.filter_top.footer.next_link = false