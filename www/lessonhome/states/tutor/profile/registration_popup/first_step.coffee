class @main extends template '../registration_popup'
  route : '/tutor/profile/first_step'
  model   : 'tutor/profile/first_step'
  title : "первый вход"
  tree : ->
    content : module '$' :
      first_name  : module 'tutor/template/forms/input'
      last_name   : module 'tutor/template/forms/input'
      patronymic  : module 'tutor/template/forms/input'
      sex_man     : module '//sex_button' :
        selector : 'man'
      sex_woman   : module '//sex_button' :
        selector : 'woman'
      birth_day   : module 'tutor/template/forms/drop_down_list'
      birth_month : module 'tutor/template/forms/drop_down_list'
      birth_year  : module 'tutor/template/forms/drop_down_list'
      status      : module 'tutor/template/forms/drop_down_list'
