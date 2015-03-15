class @main extends template '../fast_bid'
  route : '/fast_bid/second_step'
  model : 'main/application/2_step'
  title : "быстрое оформление заявки: второй шаг"
  tree : ->
    progress : 2
    content : module '$' :
      pupil_status : module 'tutor/forms/drop_down_list':
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
        handle        : true
      price_hint : module 'tutor/hint' :
        selector : 'small'
        text : 'Одно нажатие кнопки мыши для выбора дня, и двойное нажатие, чтобы ввести точное время для этого дня.'
      goal : module 'tutor/forms/textarea':
        text: 'Опишите цель :'
        selector  : 'fast_bid'
    #hint : 'Вы можете<br>отправить заявку<br>в любой момент!<br>Но чем подробнее вы<br>её заполните, тем<br>лучше мы сможем<br>подобрать Вам<br>подходящего<br>репетитора :)'

  init : ->
    @parent.tree.filter_top.footer.button_back.selector = 'fast_bid_nav'
    @parent.tree.filter_top.footer.button_back.href     = 'first_step'
    @parent.tree.filter_top.footer.issue_bid.selector   = 'fast_bid_issue'
    @parent.tree.filter_top.footer.issue_bid.href       = false
    @parent.tree.filter_top.footer.button_next.selector = 'fast_bid_nav'
    @parent.tree.filter_top.footer.button_next.href     = 'third_step'