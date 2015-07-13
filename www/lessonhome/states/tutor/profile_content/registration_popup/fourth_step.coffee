class @main extends @template '../registration_popup'
  route : '/tutor/profile/fourth_step'
  model : 'tutor/profile_registration/fourth_step'
  title : "Регистрация : шаг4"
  access : ['tutor']
  redirect : {
    'other' : '/enter'
    'pupil' : '/enter'
  }
  status :
    '!tutor_prereg_3':'/tutor/profile/second_step'
  forms : [{account:['registration_progress']}]
  tree : ->
    progress  : $form : account : 'registration_progress'
    current_progress: 4
    selector_button_back  : 'fast_bid_nav'
    href_button_back      : 'third_step'
    href_button_next      : '/tutor/profile'
    close   : true
    content : @module '$' :
      form      : @state 'about_tutor'
