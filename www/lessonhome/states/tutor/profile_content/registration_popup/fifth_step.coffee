class @main extends template '../registration_popup'
  route : '/tutor/profile/fifth_step'
  model : 'tutor/profile_registration/fifth_step'
  title : "Регистрация : шаг5"
  tree : ->
    progress  : 5
    content : module '$' :
      reason     : module 'tutor/forms/textarea' :
        height    : '87px'
        text      : 'Почему я репетитор?'
        selector  : 'first_reg up_text'
      interests  : module 'tutor/forms/textarea' :
        height    : '87px'
        text      : 'Интересы :'
        selector  : 'first_reg up_text'
      about      : module 'tutor/forms/textarea' :
        height    : '117px'
        text      : 'О себе :'
        selector  : 'first_reg up_text'


  init : ->
    @parent.tree.popup.footer.button_next.selector = 'inactive'
    @parent.tree.popup.footer.back_link = 'fourth_step'
    @parent.tree.popup.footer.next_link = false