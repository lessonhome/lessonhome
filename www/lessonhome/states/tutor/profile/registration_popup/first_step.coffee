class @main extends template '../registration_popup'
  route : '/tutor/profile/first_step'
  model : 'tutor/profile/first_step'
  title : "первый вход"
  tree : ->
    content : module '$' :
      understand_button : module '//understand_button'
      first_name  : module 'tutor/forms/input'
      last_name   : module 'tutor/forms/input'
      patronymic  : module 'tutor/forms/input'
      sex_man     : module '//sex_button' :
        selector : 'man'
      sex_woman   : module '//sex_button' :
        selector : 'woman'
      birth_day   : module 'tutor/forms/drop_down_list'
      birth_month : module 'tutor/forms/drop_down_list'
      birth_year  : module 'tutor/forms/drop_down_list'
      status      : module 'tutor/forms/drop_down_list'

  init : ->
    @parent.tree.popup.footer.back_link = '#'
    @parent.tree.popup.footer.next_link = 'second_step'
