class @main extends template '../popup'
  route : '/tutor/reports/first_call'
  model : 'tutor/bids/reports_step1_fill'
  title : "Первый звонок"
  tree : ->
    content : module '$' :
      success_button : module '//result_button' :
        selector : 'success'

      fail_button : module '//result_button' :
        selector : 'fail'


  init : ->
    @parent.tree.popup.header.text = 'Как прошёл первый звонок?'