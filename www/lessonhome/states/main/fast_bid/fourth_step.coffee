class @main extends @template '../preview'
  route : '/fast_bid/fourth_step'
  model : 'main/application/4_step'
  title : "быстрое оформление заявки: финальный шаг"
  tags  : -> 'pupil:fast_bid'
  access : ['pupil','other']
  redirect : {
    tutor : 'tutor/profile'
  }
  forms : [{account:['fast_bid_progress']}]
  tree : ->
    filter_top : @module '$' :
      thanks_icon :
        src : @F('main/application_star.png')
        height: 246
        width:  255
      progress_bar : @module 'main/fast_bid/progress_bar' :
        progress  : $form : account : 'fast_bid_progress'
        link      : false
