class @main extends template '../popup'
  route : '/tutor/reports/first_lesson_result'
  model : 'tutor/bids/reports_step3_fill'
  title : "Первое занятие"
  access : ['tutor']
  redirect : {
    'default' : 'main/first_step'
  }
  tree : ->
    content : module '$' :
      success_button : module 'tutor/forms/result_button' :
        selector : 'success'

      fail_button : module 'tutor/forms/result_button' :
        selector : 'fail'


  init : ->
    @parent.tree.popup.header.text = 'Как прошло первое занятие?'