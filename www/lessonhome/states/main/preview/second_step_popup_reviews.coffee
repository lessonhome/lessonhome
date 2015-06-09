class @main extends @template './second_step'
  route : '/second_step_popup_reviews'
  model : 'main/second_step_popup_reviews'
  title : "подробная информация о репетиторе - отчеты"
  tags  : -> 'popup_reviews_tutor'
  access : ['pupil','other']
  redirect : {
    'tutor' : 'tutor/profile'
  }
  tree : ->
    popup : @state 'tutor/profile_content/reviews_sub'
