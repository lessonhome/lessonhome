class @main extends template './second_step'
  route : '/second_step_popup_profile'
  model : 'main/second_step_popup_profile'
  title : "подробная информация о репетиторе - анкета"
  tree : ->
    popup : state 'tutor/profile_sub'