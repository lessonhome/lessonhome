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
    close     : true
    content   : @module '$' :
      form  : @state 'contacts_tutor' :
        href_back : '/tutor/profile/second_step'
        href      : '/tutor/profile/second_step_address'
        address_popup   : @exports()
  init : =>
    @parent.tree.popup.button_back.selector = 'fast_bid_nav'
    @parent.tree.popup.button_back.href = 'first_step'
    @parent.tree.popup.button_next.selector = 'fast_bid_nav'
    @parent.tree.popup.button_next.href = 'third_step'




