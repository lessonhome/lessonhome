class @main extends template '../registration_popup'
  route : '/tutor/profile/second_step'
  model : 'tutor/profile_registration/second_step'
  title : "Регистрация : шаг2"
  tree : =>
    progress  : 2
    content   : module '$' :
      form  : state 'contacts_tutor' :
        address_popup   : @exports()
  init : =>
    @parent.tree.popup.button_back.selector = 'fast_bid_nav'
    @parent.tree.popup.button_back.href = 'first_step'
    @parent.tree.popup.button_next.selector = 'fast_bid_nav'
    @parent.tree.popup.button_next.href = 'third_step'




