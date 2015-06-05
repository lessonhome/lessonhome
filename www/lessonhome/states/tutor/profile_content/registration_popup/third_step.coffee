class @main extends @template '../registration_popup'
  route : '/tutor/profile/third_step'
  model : 'tutor/profile_registration/third_step'
  title : "Регистрация : шаг3"
  access : ['tutor']
  redirect : {
    'default' : 'main/first_step'
  }
  status :
    '!tutor_prereg_2':'/tutor/profile/second_step'
  forms : [{account:['registration_progress']}]
  tree : =>
    progress  : $form : account : 'registration_progress'
    close   : true
    content : @module '$' :
      form : @state 'subject_tutor'

  init : =>
    @parent.tree.popup.button_back.selector = 'fast_bid_nav'
    @parent.tree.popup.button_back.href     = 'second_step'
    @parent.tree.popup.button_next.selector = 'fast_bid_nav'
    @parent.tree.popup.button_next.href     = 'fourth_step'
