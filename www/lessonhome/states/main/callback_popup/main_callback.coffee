class @main extends @template '../first_step'
  route : '/main_callback'
  model : 'main/first_step.2'
  title : "обратный звонок"
  access : ['pupil', 'other']
  redirect : {
    'tutor' : '/main_tutor_callback'
  }
  tree : ->
    popup : @state '../call_back_popup' :
      href: '/first_step'







