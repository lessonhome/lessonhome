class @main extends template '../preview'
  route : '/fast_bid/fifth_step'
  model : 'main/application/5_step'
  title : "быстрое оформление заявки: финальный шаг"
  tree : ->
    filter_top : module '$' :
      thanks_icon :
        src : F('main/application_star.png')
        height: 246
        width:  255
      progress_bar : module 'main/fast_bid/progress_bar' :
        progress : 5