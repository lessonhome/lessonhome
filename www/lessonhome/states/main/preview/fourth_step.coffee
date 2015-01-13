class @main extends template '../preview'
  route : '/fourth_step'
  model : 'main/fourth_step'
  title : "выберите диапозон цены"
  tree : =>
    filter_top  : state '../filter_top' :
      title : 'Выберите диапозон цены :'
      price_slider_top   : state '../slider_main' :
        selector      : 'price_slider_top'
        start         : 'price_start'
        end           : 'price_end'
        measurement   : 'руб.'
        selector_two  : 'selector_move'