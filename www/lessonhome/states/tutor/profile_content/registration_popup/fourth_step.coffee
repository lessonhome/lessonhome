class @main extends template '../registration_popup'
  route : '/tutor/profile/fourth_step'
  model : 'tutor/profile_registration/fourth_step'
  title : "Регистрация : шаг4"
  tree : ->
    progress  : 4
    content : module '$' :
      form      : state 'about_tutor'

  init : ->
    @parent.tree.popup.button_back.selector = 'fast_bid_nav'
    @parent.tree.popup.button_back.href = 'third_step'
    @parent.tree.popup.button_next.selector = 'fast_bid_nav'
    @parent.tree.popup.button_next.href = '/tutor/profile'


