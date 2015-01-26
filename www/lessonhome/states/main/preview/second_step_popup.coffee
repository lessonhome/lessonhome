class @main extends template './second_step'
  route : '/second_step_popup'
  model : 'main/second_step_popup'
  title : "выберите статус преподователя"
  tree : ->
    popup : state 'tutor/profile/profile_sub'