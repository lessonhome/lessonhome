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
    close   : true
    content : @module '$' :
      form      : @state 'about_tutor'

  init : ->
    @parent.tree.popup.button_back.selector = 'fast_bid_nav'
    @parent.tree.popup.button_back.href = 'third_step'
    @parent.tree.popup.button_next.selector = 'fast_bid_nav'
    @parent.tree.popup.button_next.href = '/tutor/profile'
