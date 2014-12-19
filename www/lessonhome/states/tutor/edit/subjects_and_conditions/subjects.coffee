class @main extends template 'tutor/template/template'
  route : '/tutor/edit/subjects'
  model   : 'tutor/edit/description/subjects'
  tree : ->
    sub_top_menu : state 'tutor/template/sub_top_menu' :
      items :
        'Предметы'     : 'subjects'
        'Место'        : 'location'
        'Календарь'    : 'calendar'
        'Предпочтения' : 'preferences'
      active_item : 'Предметы'
    content : module 'tutor/edit/conditions/subjects':
      subject           : module 'tutor/template/forms/drop_down_list'
      sections          : module 'tutor/template/forms/drop_down_list'
      destinations      : module 'tutor/template/forms/drop_down_list'
      category_students : module 'tutor/template/forms/drop_down_list'
      location          : module 'tutor/template/forms/drop_down_list'
      location_add      : module 'tutor/template/button' :
        text  : '+'
      price             : module 'tutor/template/forms/drop_down_list'
      add_location      : module 'tutor/template/button' :
        text      : '+'
        selector  : 'add'
      pupils_number     : module 'tutor/template/forms/drop_down_list'
      bet               : module 'tutor/template/forms/drop_down_list'
      comments          : module 'tutor/template/forms/textarea' :
        id     : 'comments'
        height : '82px'
      add_button        : module 'tutor/template/button' :
        text      : '+ Добавить'
        selector  : 'fixed'
      save_button       : module 'tutor/template/button' :
        text      : 'Сохранить'
        selector  : 'fixed'

  init : ->
    @parent.setTopMenu 'Условия', {
      'Описание': 'general'
      'Условия': 'subjects'
    }

    @parent.tree.left_menu.setActive 'Анкета'
    @parent.tree.left_menu.setLinks ['../profile', '../bids', '#', '#', '#', '#', '#']


