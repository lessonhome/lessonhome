class @main  extends @template '../lp'
  route : '/calc'
  model   : 'tutor/bids/reports'
  title : "Калькулятор стоимости заявки"
  access : ['other']
  redirect : {}
  tree : =>
    content : @module '$' :
      freq : @state 'main/slider_main' :
        selector      : 'time_fast_bids'
        default :
          left : 1
          right : 1
        right : $urlform : mainFilter : 'price.right'
        min : 500
        max : 3500
        type : 'default'
        dash          : '-'
        measurement   : 'руб.'
        division_value : 50



