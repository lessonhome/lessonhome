class @main extends template '../registration_popup'
  route : '/tutor/profile/profile_registration/second_step'
  model : 'tutor/profile/second_step'
  title : "Регистрация : шаг2"
  tree : ->
    content : module '$' :
      country : module 'tutor/forms/drop_down_list'
      city    : module 'tutor/forms/drop_down_list'
      address_button : module '//address_button'
      line    : module 'tutor/separate_line' :
        selector : 'horizon'
      mobile_phone   : module 'tutor/forms/input'
      extra_phone    : module 'tutor/forms/input'
      post    : module 'tutor/forms/input'
      skype   : module 'tutor/forms/input'
      site    : module 'tutor/forms/input'

  init : ->
    @parent.tree.popup.progress_bar.progress = 2
    @parent.tree.popup.footer.back_link = 'first_step'
    @parent.tree.popup.footer.next_link = 'third_step'

