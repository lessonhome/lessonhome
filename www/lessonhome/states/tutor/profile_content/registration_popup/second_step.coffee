class @main extends template '../registration_popup'
  route : '/tutor/profile/second_step'
  model : 'tutor/profile_registration/second_step'
  title : "Регистрация : шаг2"
  tree : ->
    progress  : 2
    content   : module '$' :
      country : module 'tutor/forms/drop_down_list' :
        text        : 'Страна :'
        selector    : 'first_reg'
      city    : module 'tutor/forms/drop_down_list' :
        text        : 'Город :'
        selector    : 'first_reg'
      address_button : module '//address_button'
      line    : module 'tutor/separate_line' :
        selector : 'horizon'
      mobile_phone  : module 'tutor/forms/input' :
        text      : 'Мобильный телефон :'
        selector  : 'first_reg'
      extra_phone   : module 'tutor/forms/input' :
        text      : 'Доп. телефон :'
        selector  : 'first_reg'
      post          : module 'tutor/forms/input' :
        text      : 'Почта :'
        selector  : 'first_reg'
      skype         : module 'tutor/forms/input' :
        text      : 'Skype :'
        selector  : 'first_reg'
      site          : module 'tutor/forms/input' :
        text      : 'Личный сайт :'
        selector  : 'first_reg'

  init : ->
    @parent.tree.popup.footer.back_link = 'first_step'
    @parent.tree.popup.footer.next_link = 'third_step'

