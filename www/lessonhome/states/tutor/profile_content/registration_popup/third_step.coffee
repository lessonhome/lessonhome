class @main extends template '../registration_popup'
  route : '/tutor/profile/third_step'
  model : 'tutor/profile_registration/third_step'
  title : "Регистрация : шаг3"
  tree : ->
    progress  : 3
    content : module '$' :
      subject                : module 'tutor/forms/drop_down_list' :
        text      : 'Предмет :'
        selector  : 'first_reg'
      categories             : module 'tutor/forms/drop_down_list' :
        text      : 'Разделы :'
        selector  : 'first_reg'
      directions             : module 'tutor/forms/drop_down_list' :
        text      : 'Направления :'
        selector  : 'first_reg'
      categories_of_students : module 'tutor/forms/drop_down_list' :
        text      : 'Предмет :'
        selector  : 'first_reg'
      place                  : module 'tutor/forms/drop_down_list' :
        text      : 'Место :'
        selector  : 'first_reg place'
      price                  : module 'tutor/forms/input' :
        text      : 'Цена :'
        selector  : 'first_reg price'
      price_button           : module '//price_button'
      students_in_group       : module 'tutor/forms/drop_down_list' :
        text      : 'Групповые занятия :'
        selector  : 'first_reg group'
      group_lessons_bet       : module 'tutor/forms/drop_down_list' :
        placeholder : 'Ставка'
        selector    : 'first_reg bet'
      comments                : module 'tutor/forms/textarea' :
        height    : '80px'
        text      : 'Комментарии :'
        selector  : 'first_reg'
      add_button              : module 'tutor/button' :
        text     : '+Добавить'
        selector : 'reg_add'

  init : ->
    @parent.tree.popup.footer.back_link = 'second_step'
    @parent.tree.popup.footer.next_link = 'fourth_step'
