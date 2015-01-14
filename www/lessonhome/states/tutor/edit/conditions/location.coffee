class @main extends template '../../../tutor'
  route : '/tutor/edit/location'
  model   : 'tutor/edit/conditions/location'
  title : "редактирование место"
  tree : =>
    items : [
      module 'tutor/header/button' : {
        title : 'Описание'
        href  : '/tutor/edit/general'
      }
      module 'tutor/header/button' : {
        title : 'Условия'
        href  : '/tutor/edit/subjects'
      }
    ]
    sub_top_menu : state 'tutor/sub_top_menu' :
      items :
        'Предметы'     : 'subjects'
        'Место'        : 'location'
        'Календарь'    : 'calendar'
        'Предпочтения' : 'preferences'
      active_item : 'Место'
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
      country       : module 'tutor/forms/drop_down_list'
      city          : module 'tutor/forms/drop_down_list'
      district      : module 'tutor/forms/drop_down_list'
      nearest_metro : module 'tutor/forms/drop_down_list'
      street        : module 'tutor/forms/input'
      house         : module 'tutor/forms/input'
      building      : module 'tutor/forms/input'
      flat          : module 'tutor/forms/input'
      add_button    : module 'tutor/button' :
        text      : '+ Добавить'
        selector  : 'fixed'
      save_button   : module 'tutor/button' :
        text      : 'Сохранить'
        selector  : 'fixed'

  init : ->
    @parent.tree.left_menu.setActive 'Анкета'
    @parent.tree.left_menu.setLinks ['../profile', '../search_bids', '#', '#', '#', '#', '#']




