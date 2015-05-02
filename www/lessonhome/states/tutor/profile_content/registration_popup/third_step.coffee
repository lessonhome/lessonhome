class @main extends template '../registration_popup'
  route : '/tutor/profile/third_step'
  model : 'tutor/profile_registration/third_step'
  title : "Регистрация : шаг3"
  access : ['tutor']
  redirect : {
    'default' : 'main/first_step'
  }
  status :
    '!tutor_prereg_2':'/tutor/profile/second_step'
  tree : =>
    progress  : data('registration_progress').get().then (p=0)=> p+1
    #data('tutor').get('registration_progress')
    content : module '$' :
      form : state 'subject_tutor'

  init : =>
    @parent.tree.popup.button_back.selector = 'fast_bid_nav'
    @parent.tree.popup.button_back.href     = 'second_step'
    @parent.tree.popup.button_next.selector = 'fast_bid_nav'
    @parent.tree.popup.button_next.href     = 'fourth_step'
