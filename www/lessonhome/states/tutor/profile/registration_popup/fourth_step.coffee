class @main extends template '../registration_popup'
  route : '/tutor/profile/fourth_step'
  model : 'tutor/profile_registration/fourth_step'
  title : "Регистрация : шаг4"
  tree : ->
    content : module '$' :

      tutor : module 'tutor/forms/location_button' :
        active : true
        text   : 'У себя'
      student  : module 'tutor/forms/location_button' :
        active : false
        text   : 'У ученика'
      web : module 'tutor/forms/location_button' :
        active : false
        text   : 'Удалённо'


      country : module 'tutor/forms/drop_down_list'
      city    : module 'tutor/forms/drop_down_list'
      area    : module 'tutor/forms/drop_down_list'
      near_metro : module 'tutor/forms/input'
      street     : module 'tutor/forms/input'
      house      : module 'tutor/forms/input'
      building   : module 'tutor/forms/input'
      flat       : module 'tutor/forms/input'
      add_button : module 'tutor/button' :
        text     : '+Добавить'
        selector : 'reg_add'


  init : ->
    @parent.tree.popup.progress_bar.progress = 4
    @parent.tree.popup.footer.back_link = 'third_step'
    @parent.tree.popup.footer.next_link = 'fifth_step'


