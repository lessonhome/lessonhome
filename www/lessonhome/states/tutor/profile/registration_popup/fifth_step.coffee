class @main extends template '../registration_popup'
  route : '/tutor/profile/fifth_step'
  model : 'tutor/profile_registration/fifth_step'
  title : "Регистрация : шаг5"
  tree : ->
    content : module '$' :
      reason     : module 'tutor/forms/textarea' :
        height : '87px'
      interests  : module 'tutor/forms/textarea' :
        height : '87px'
      about      : module 'tutor/forms/textarea' :
        height : '117px'


  init : ->
    @parent.tree.popup.footer.button_next.selector = 'inactive'
    @parent.tree.popup.progress_bar.progress = 5
    @parent.tree.popup.footer.back_link = 'fourth_step'
    @parent.tree.popup.footer.next_link = false