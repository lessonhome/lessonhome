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

  init : ->
    @parent.tree.filter_top.progress_bar.progress = 4
    @parent.tree.filter_top.footer.button_back.selector = 'active'
    @parent.tree.filter_top.footer.issue_bid.selector = 'active'
    @parent.tree.filter_top.footer.back_link = 'third_step'
    @parent.tree.filter_top.footer.next_link = 'fifth_step'