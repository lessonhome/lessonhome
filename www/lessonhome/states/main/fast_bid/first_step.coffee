class @main extends template '../fast_bid'
  route : '/fast_bid/first_step'
  model : 'main/application/1_step'
  title : "быстрое оформление заявки: первый шаг"
  tree : ->
    progress : 1
    content : module '$' :
      name : module 'tutor/forms/input' :
        text      : 'Имя :'
        selector  : 'fast_bid'
      phone : module 'tutor/forms/input':
        text: 'Телефон :'
        selector  : 'fast_bid'
      email : module 'tutor/forms/input':
        text: 'E-mail :'
        selector  : 'fast_bid'
      subject :module 'tutor/forms/drop_down_list':
        text: 'Предмет :'
        selector  : 'fast_bid'
      call_time : module 'tutor/forms/textarea':
        text: 'В какое время Вам звонить :'
        selector  : 'fast_bid'
      comments : module 'tutor/forms/textarea':
        text: 'Комментарии :'
        selector  : 'fast_bid'
    hint : 'Вы можете<br>отправить заявку<br>в любой момент!<br>Но чем подробнее вы<br>её заполните, тем<br>лучше мы сможем<br>подобрать Вам<br>подходящего<br>репетитора :)'

  init : ->
    @parent.tree.filter_top.footer.button_back.selector = 'hidden'
    @parent.tree.filter_top.footer.issue_bid.selector = 'inactive'
    @parent.tree.filter_top.footer.back_link = false
    @parent.tree.filter_top.footer.next_link = 'second_step'

