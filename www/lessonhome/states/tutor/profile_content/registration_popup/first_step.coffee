class @main extends template '../registration_popup'
  route : '/tutor/profile/first_step'
  model : 'tutor/profile_registration/first_step'
  title : "первый вход"
  tree : ->
    progress  : 1
    content : module '$' :
      understand_button : module 'tutor/button' :
        selector: 'understand'
        text:      'Спасибо, я понял'
      general_data      : state 'general_data'
  init : ->
    @parent.tree.popup.footer.button_back.selector = 'inactive'
    @parent.tree.popup.footer.back_link = false
    @parent.tree.popup.footer.next_link = 'second_step'
