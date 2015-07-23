class @main extends @template '../main_tutor'
  route : '/main_tutor_callback'
  model : 'main/first_step.2'
  title : "обратный звонок"
  access : ['tutor', 'pupil', 'other']
  tree : ->
    popup : @state '../call_back_popup' :
      href: '/main_tutor'
