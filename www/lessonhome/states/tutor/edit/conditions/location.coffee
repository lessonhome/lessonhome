class @main extends template '../../../tutor'
  route : '/tutor/edit/location'
  model   : 'tutor/edit/description/location'
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
    content : module 'tutor/edit/conditions/location' :
      location : module 'tutor/choice' :
        id          : 'location'
        indent      : '30px'
        choice_list : [
          module 'tutor/button' :
            text      : 'У себя'
            selector  : 'fixed'

          module 'tutor/button' :
            text      : 'У ученика'
            selector  : 'fixed'

          module 'tutor/button' :
            text      : 'Удалённо'
            selector  : 'fixed'
        ]
      country       : module 'tutor/forms/drop_down_list'
      city          : module 'tutor/forms/drop_down_list'
      district      : module 'tutor/forms/drop_down_list'
      nearest_metro : module 'tutor/forms/drop_down_list'
      street        : module 'tutor/forms/drop_down_list'
      house         : module 'tutor/forms/drop_down_list'
      building      : module 'tutor/forms/drop_down_list'
      flat          : module 'tutor/forms/drop_down_list'
      add_button    : module 'tutor/button' :
        text      : '+ Добавить'
        selector  : 'fixed'
      save_button   : module 'tutor/button' :
        text      : 'Сохранить'
        selector  : 'fixed'

  init : ->
    @parent.tree.left_menu.setActive 'Анкета'
    @parent.tree.left_menu.setLinks ['../profile', '../search_bids', '#', '#', '#', '#', '#']
