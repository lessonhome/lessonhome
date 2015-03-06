class @main extends template '../registration_popup'
  route : '/tutor/profile/third_step'
  model : 'tutor/profile_registration/third_step'
  title : "Регистрация : шаг3"
  tree : ->
    progress  : 3
    content : module '$' :
      subject_tutor : state 'subject_tutor'

  init : ->
    @parent.tree.popup.footer.back_link = 'second_step'
    @parent.tree.popup.footer.next_link = 'fourth_step'
