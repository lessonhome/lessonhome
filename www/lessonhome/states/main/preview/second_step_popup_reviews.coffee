class @main extends template './second_step'
  route : '/second_step_popup_reviews'
  model : 'main/second_step_popup_reviews'
  title : "подробная информация о репетиторе - отчеты"
  tree : ->
    popup : state 'tutor/profile/reviews_sub'