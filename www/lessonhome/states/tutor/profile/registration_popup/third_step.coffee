class @main extends template '../registration_popup'
  route : '/tutor/profile/third_step'
  model : 'tutor/profile/profile_registration/third_step'
  title : "Регистрация : шаг3"
  tree : ->
    content : module '$' :
      subject                : module 'tutor/forms/drop_down_list'
      categories             : module 'tutor/forms/drop_down_list'
      directions             : module 'tutor/forms/drop_down_list'
      categories_of_students : module 'tutor/forms/drop_down_list'
      place                  : module 'tutor/forms/drop_down_list'
      price                  : module 'tutor/forms/input'
      price_button           : module '//price_button'
      students_in_group      : module 'tutor/forms/drop_down_list'
      group_lessons_bet      : module 'tutor/forms/drop_down_list'
      comments               : module 'tutor/forms/textarea' :
        height : '80px'
      add_button             : module '//add_button'

  init : ->
    @parent.tree.popup.progress_bar.progress = 3
    @parent.tree.popup.footer.back_link = 'second_step'
    @parent.tree.popup.footer.next_link = 'fourth_step'
