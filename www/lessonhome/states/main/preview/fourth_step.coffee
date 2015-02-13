class @main extends template '../preview'
  route : '/fourth_step'
  model : 'main/fourth_step'
  title : "выберите диапазон цены"
  tree : =>
    filter_top  : state '../filter_top' :
      title : 'Выберите диапазон цены :'
      price_slider_top   : state '../slider_main' :
        selector      : 'price_slider_top'
        start         : 'price'
        start_text    : 'от'
        end           : 'price'
        end_text      : 'до'
        measurement   : 'руб.'
        selector_two  : 'selector_move'