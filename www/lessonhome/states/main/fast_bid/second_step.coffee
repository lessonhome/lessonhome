class @main extends template '../fast_bid'
  route : '/fast_bid/second_step'
  model : 'main/application/2_step'
  title : "быстрое оформление заявки: второй шаг"
  tree : ->
    progress : 2
    content : module '$' :
      your_status : module 'tutor/forms/drop_down_list':
        text: 'Ваш статус :'
        selector  : 'fast_bid'
      course : module 'tutor/forms/drop_down_list':
        text: 'Курс :'
        selector  : 'fast_bid'
      knowledge_level : module 'tutor/forms/drop_down_list':
        text: 'Уровень знаний :'
        selector  : 'fast_bid'
      price_slider_bids   : state '../slider_main' :
        selector      : 'price_slider_bids'
        start         : 'price_bids'
        start_text    : 'от'
        end         : module 'tutor/forms/input' :
          selector  : 'price_bids'
          text      : 'до'
        measurement   : 'руб.'
        selector_two  : 'bids_move'
      goal : module 'tutor/forms/textarea':
        text: 'Опишите цель :'
        selector  : 'fast_bid'
    hint : 'Вы можете<br>отправить заявку<br>в любой момент!<br>Но чем подробнее вы<br>её заполните, тем<br>лучше мы сможем<br>подобрать Вам<br>подходящего<br>репетитора :)'

  init : ->
    @parent.tree.filter_top.footer.back_link = 'first_step'
    @parent.tree.filter_top.footer.next_link = 'third_step'