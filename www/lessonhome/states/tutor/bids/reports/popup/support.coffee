class @main extends template '../popup'
  route : '/tutor/reports/support'
  model : 'tutor/bids/reports_help'
  title : "Поддержка"
  access : ['tutor']
  redirect : {
    'default' : 'main/first_step'
  }
  tree : ->
    content : module '$' :
      title : 'Возникли вопросы/проблемы в ходе заявки?<br>Напишите оператору курирующему данную заявку.'

  init : ->
    @parent.tree.popup.header.text = 'Поддержка'