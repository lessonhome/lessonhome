class @main extends @template './second_step'
  route : '/second_step_popup_conditions'
  model : 'main/second_step_popup_conditions'
  title : "подробная информация о репетиторе - условия"
  tags  : -> 'popup_conditions_tutor'
  access : ['pupil','other']
  redirect : {
    'default' : 'main/first_step'
  }
  tree  : ->
    popup : @state 'tutor/profile_content/conditions_sub'
