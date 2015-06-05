class @main extends @template '../first_step'
  route : '/main_callback'
  model : 'main/first_step.2'
  title : "обратный звонок"
  access : ['pupil', 'tutor', 'other']
  redirect : {
  }
  tree : ->
    popup : @state '../call_back_popup' :
      href: '/first_step'







