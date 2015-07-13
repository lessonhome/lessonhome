class @main extends @template '../registration_popup'
  route : '/tutor/profile/second_step'
  model : 'tutor/profile_registration/second_step'
  title : "Регистрация : шаг2"
  access : ['tutor']
  redirect : {
    'other' : '/enter'
    'pupil' : '/enter'
  }
  status : {
    '!tutor_prereg_1':'/tutor/profile/first_step'
  }
  forms : [{account:['registration_progress']}]
  tree : =>
    progress  : $form : account : 'registration_progress'
    current_progress: 2
    selector_button_back  : 'fast_bid_nav'
    href_button_back      : 'first_step'
    href_button_next      : 'third_step'
    close     : true
    content   : @module '$' :
      form  : @state 'contacts_tutor' :
        href_back : '/tutor/profile/second_step'
        href      : '/tutor/profile/second_step_address'
        address_popup   : @exports()




