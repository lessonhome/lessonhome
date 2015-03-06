class @main extends template '../popup'
  route : '/tutor/reports/first_lesson_date'
  model : 'tutor/bids/reports_step2_fill'
  title : "Дата первого занятия"
  tree : ->
    content : module '$' :
      date : module 'tutor/forms/input' :
        text : 'Дата'
        selector : 'report_popup'
      time : module 'tutor/forms/input' :
        text : 'Время'
        selector : 'report_popup time_report_popup'

  init : ->
    @parent.tree.popup.header.text = 'Дата первого занятия'