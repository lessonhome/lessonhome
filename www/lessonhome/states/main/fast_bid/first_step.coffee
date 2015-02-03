class @main extends template '../fast_bid'
  route : '/fast_bid/first_step'
  model : 'main/application/1_step'
  title : "быстрое оформление заявки: первый шаг"
  tree : ->
    content : module '$' :
      name : module 'tutor/forms/input'
      faculty : module 'tutor/forms/input'
      phone : module 'tutor/forms/input'
      email : module 'tutor/forms/input'
      subject :module 'tutor/forms/drop_down_list'
      call_time : module 'tutor/forms/textarea'
      comments : module 'tutor/forms/textarea'
      hint : 'Вы можете<br>отправить заявку<br>в любой момент!<br>Но чем подробнее вы<br>её заполните, тем<br>лучше мы сможем<br>подобрать Вам<br>подходящего<br>репетитора :)'

  init : ->
    @parent.tree.filter_top.footer.button_back.selector = 'hidden'
    @parent.tree.filter_top.footer.issue_bid.selector = 'inactive'
    @parent.tree.filter_top.footer.back_link = false
    @parent.tree.filter_top.footer.next_link = 'second_step'

