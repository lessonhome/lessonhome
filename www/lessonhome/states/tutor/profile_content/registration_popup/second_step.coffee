class @main extends template '../registration_popup'
  route : '/tutor/profile/second_step'
  model : 'tutor/profile_registration/second_step'
  title : "Регистрация : шаг2"
  tree : ->
    progress  : 2
    content   : module '$' :
      contacts_tutor  : state 'contacts_tutor'

  init : ->
    @parent.tree.popup.footer.back_link = 'first_step'
    @parent.tree.popup.footer.next_link = 'third_step'



