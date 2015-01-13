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
      country       : module 'tutor/forms/drop_down_list' :
        id : 'country_label'
      city          : module 'tutor/forms/drop_down_list' :
        id : 'city_label'
      district      : module 'tutor/forms/drop_down_list' :
        id : 'district_label'
      nearest_metro : module 'tutor/forms/drop_down_list' :
        id : 'nearest_metro_label'
      street        : module 'tutor/forms/input' :
        id : 'street_label'
      house         : module 'tutor/forms/input' :
        id : 'house_label'
      building      : module 'tutor/forms/input' :
        id : 'building_label'
      flat          : module 'tutor/forms/input' :
        id : 'flat_label'
      add_button    : module 'tutor/button' :
        text      : '+ Добавить'
        selector  : 'fixed'
      save_button   : module 'tutor/button' :
        text      : 'Сохранить'
        selector  : 'fixed'

  init : ->
    @parent.tree.left_menu.setActive 'Анкета'
    @parent.tree.left_menu.setLinks ['../profile', '../search_bids', '#', '#', '#', '#', '#']




