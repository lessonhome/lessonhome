
class @main extends template 'tutor/template/template'
  route : '/tutor/edit/location'
  tree : ->
    sub_top_menu : state 'tutor/template/sub_top_menu' :
      items :
        'Предметы'     : 'subjects'
        'Место'        : 'location'
        'Календарь'    : 'calendar'
        'Предпочтения' : 'preferences'
      active_item : 'Место'
    content : module 'tutor/edit/conditions/location' :
      location : module 'tutor/template/choice' :
        id          : 'location'
        indent      : '30px'
        choice_list : [
          module 'tutor/template/button' :
            text      : 'У себя'
            selector  : 'fixed'

          module 'tutor/template/button' :
            text      : 'У ученика'
            selector  : 'fixed'

          module 'tutor/template/button' :
            text      : 'Удалённо'
            selector  : 'fixed'
        ]
      country       : module 'tutor/template/forms/drop_down_list'
      city          : module 'tutor/template/forms/drop_down_list'
      district      : module 'tutor/template/forms/drop_down_list'
      nearest_metro : module 'tutor/template/forms/drop_down_list'
      street        : module 'tutor/template/forms/drop_down_list'
      house         : module 'tutor/template/forms/drop_down_list'
      building      : module 'tutor/template/forms/drop_down_list'
      flat          : module 'tutor/template/forms/drop_down_list'
      add_button    : module 'tutor/template/button' :
        text      : '+ Добавить'
        selector  : 'fixed'
      save_button   : module 'tutor/template/button' :
        text      : 'Сохранить'
        selector  : 'fixed'

  init : ->
    @parent.setTopMenu 'Условия', {
      'Описание': 'general'
      'Условия': 'subjects'
    }

    @parent.tree.left_menu.setActive 'Анкета'
    @parent.tree.left_menu.setLinks ['../profile', '../bids', '#', '#', '#', '#', '#']
