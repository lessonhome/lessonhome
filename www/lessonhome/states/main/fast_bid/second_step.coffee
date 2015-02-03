class @main extends template '../fast_bid'
  route : '/fast_bid/second_step'
  model : 'main/application/2_step'
  title : "быстрое оформление заявки: второй шаг"
  tree : ->
    content : module '$' :
      your_status : module 'tutor/forms/drop_down_list'
      course : module 'tutor/forms/drop_down_list'
      knowledge_level : module 'tutor/forms/drop_down_list'
      price_from : module 'tutor/forms/input'
      price_to : module 'tutor/forms/input'
      price_slider : module 'slider'
      goal : module 'tutor/forms/textarea'
      hint : 'Вы можете<br>отправить заявку<br>в любой момент!<br>Но чем подробнее вы<br>её заполните, тем<br>лучше мы сможем<br>подобрать Вам<br>подходящего<br>репетитора :)'

  init : ->
    @parent.tree.filter_top.progress_bar.progress = 2
    @parent.tree.filter_top.footer.back_link = 'first_step'
    @parent.tree.filter_top.footer.next_link = 'third_step'