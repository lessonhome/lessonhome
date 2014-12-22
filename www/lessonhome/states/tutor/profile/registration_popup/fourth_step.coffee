class @main extends template '../registration_popup'
  route : '/tutor/profile/fourth_step'
  model : 'tutor/profile/fourth_step'
  title : "Регистрация : шаг4"
  tree : ->
    content : module '$' :

      tutor : module '//location_button' :
        active : true
        text   : 'У себя'
      student  : module '//location_button' :
        active : false
        text   : 'У ученика'
      web : module '//location_button' :
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
      add_button : module '//add_button'


  init : ->
    @parent.tree.popup.progress_bar.progress = 4
    @parent.tree.popup.footer.back_link = 'third_step'
    @parent.tree.popup.footer.next_link = 'fifth_step'


