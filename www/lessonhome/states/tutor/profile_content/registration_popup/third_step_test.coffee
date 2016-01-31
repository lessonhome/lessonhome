class @main extends @template '../registration_popup'
  route : '/tutor/profile/third_step'
  model : 'tutor/profile_registration/third_step'
  title : "Регистрация : шаг3"
  access : ['tutor']
  status : {
    '!tutor_prereg_2':'/tutor/profile/second_step'
  }
  redirect : {
    'other' : '/enter'
    'pupil' : '/enter'
  }
  forms : [{account:['registration_progress']}]
  tree : =>
    progress  : $form : account : 'registration_progress'
    current_progress: 3
    selector_button_back  : 'fast_bid_nav'
    href_button_back      : 'second_step'
    href_button_next      : 'fourth_step'
    close   : true
    content : @module '$' :
      form : @state 'subjects_tutor_test'
