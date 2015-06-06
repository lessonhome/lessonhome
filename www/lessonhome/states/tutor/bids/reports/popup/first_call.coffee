class @main extends @template '../popup'
  route : '/tutor/reports/first_call'
  model : 'tutor/bids/reports_step1_fill'
  title : "Первый звонок"
  access : ['tutor']
  redirect : {
    'other' : 'main/first_step'
    'pupil' : 'main/first_step'
  }
  tree : ->
    content : @module '$' :
      success_button : @module 'tutor/forms/result_button' :
        selector : 'success'

      fail_button : @module 'tutor/forms/result_button' :
        selector : 'fail'


  init : ->
    @parent.tree.popup.header.text = 'Как прошёл первый звонок?'