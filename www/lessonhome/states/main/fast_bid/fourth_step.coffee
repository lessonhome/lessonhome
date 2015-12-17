class @main  extends @template '../../lp'
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
    content : @module '$' :
      progress_bar : @module 'main/fast_bid/progress_bar' :
        progress  : $form : account : 'fast_bid_progress'
        link      : false
