class @main extends template '../registration_popup'
  route : '/tutor/profile/fourth_step'
  model : 'tutor/profile_registration/fourth_step'
  title : "Регистрация : шаг4"
  tree : ->
    progress  : 4
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


      country : module 'tutor/forms/drop_down_list' :
        text      : 'Страна :'
        selector  : 'first_reg'
      city    : module 'tutor/forms/drop_down_list' :
        text      : 'Город :'
        selector  : 'first_reg'
      area    : module 'tutor/forms/drop_down_list' :
        text      : 'Район :'
        selector  : 'first_reg'
      near_metro : module 'tutor/forms/input' :
        text      : 'Ближайшее метро :'
        selector  : 'first_reg'
      street     : module 'tutor/forms/input' :
        text      : 'Улица :'
        selector  : 'first_reg'
      house      : module 'tutor/forms/input' :
        text      : 'Дом :'
        selector  : 'first_reg house'
      building   : module 'tutor/forms/input' :
        text      : 'Строение :'
        selector  : 'first_reg house'
      flat       : module 'tutor/forms/input' :
        text      : 'Квартира :'
        selector  : 'first_reg house'
      add_button : module 'tutor/button' :
        text     : '+Добавить'
        selector : 'reg_add'


  init : ->
    @parent.tree.popup.footer.back_link = 'third_step'
    @parent.tree.popup.footer.next_link = 'fifth_step'


