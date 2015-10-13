class @main extends @template '../registration_popup'
  route : '/tutor/profile/fifth_step'
  model : 'tutor/profile_registration/fourth_step'
  title : "Регистрация : шаг5"
  access : ['tutor']
  redirect : {
    'other' : '/enter'
    'pupil' : '/enter'
  }
  status :
    '!tutor_prereg_4':'/tutor/profile/fourth_step'
  forms : [{account:['registration_progress']}]
  tree : ->
    progress  : $form : account : 'registration_progress'
    current_progress: 5
    selector_button_back  : 'fast_bid_nav'
    href_button_back      : 'fourth_step'
    href_button_next      : '/tutor/profile'
    selector : 'center'
    close   : true
    content : @module '$' :
      form      : @state 'tutor/edit/description/education_item'
