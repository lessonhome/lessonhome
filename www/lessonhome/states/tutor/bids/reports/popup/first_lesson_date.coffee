class @main extends template '../popup'
  route : '/tutor/reports/first_lesson_date'
  model : 'tutor/bids/reports_step2_fill'
  title : "Дата первого занятия"
  tree : ->
    content : module '$' :
      date : module 'tutor/forms/input' :
        text2 : 'Дата'
        selector : 'calendar'
      time : module 'tutor/forms/input' :
        text2 : 'Время'
        selector : 'calendar'

  init : ->
    @parent.tree.popup.header.text = 'Дата первого занятия'
