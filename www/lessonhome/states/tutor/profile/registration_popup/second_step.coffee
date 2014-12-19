class @main extends template '../registration_popup'
  route : '/tutor/profile/second_step'
  model : 'tutor/profile/second_step'
  title : "Регистрация : шаг2"
  tree : ->
    content : module '$' :
      country : module 'tutor/template/forms/drop_down_list'
      city    : module 'tutor/template/forms/drop_down_list'
      address_button : module '//address_button'
      line    : module 'tutor/template/separate_line' :
        selector : 'horizon'
      mobile_phone   : module 'tutor/template/forms/input'
      extra_phone    : module 'tutor/template/forms/input'
      post    : module 'tutor/template/forms/input'
      skype   : module 'tutor/template/forms/input'
      site    : module 'tutor/template/forms/input'

    footer : module '//footer' :
      back_link : 'first_step'
      next_link : '#'

  init : ->
    @parent.tree.popup.progress_bar.progress = 2
    @parent.tree.popup.footer.back_link = 'first_step'
    @parent.tree.popup.footer.next_link = '#'