class @main extends @template '../registration_popup'
  route : '/tutor/profile/third_step_test'
  model : 'tutor/profile_registration/third_step'
  title : "Регистрация : шаг3"
  access : ['tutor']
  redirect : {
    'other' : '/enter'
    'pupil' : '/enter'
  }
  tree : =>
    progress  : $form : account : 'registration_progress'
    current_progress: 3
    selector_button_back  : 'fast_bid_nav'
    href_button_back      : 'second_step'
    href_button_next      : 'fourth_step'
    close   : true
    content : @module '$' :
      form : @state 'add_tutor_test'
