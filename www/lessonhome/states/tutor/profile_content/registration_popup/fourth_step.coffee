class @main extends template '../registration_popup'
  route : '/tutor/profile/fourth_step'
  model : 'tutor/profile_registration/fourth_step'
  title : "Регистрация : шаг4"
  tree : ->
    progress  : 4
    content : module '$' :
      place_tutor : state 'place_tutor'

  init : ->
    @parent.tree.popup.footer.back_link = 'third_step'
    @parent.tree.popup.footer.next_link = 'fifth_step'


