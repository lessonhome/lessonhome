class @main extends template '../../../tutor'
  route : '/tutor/edit/subjects'
  model   : 'tutor/edit/conditions/subjects'
  title : "редактирование предметы"
  tags : -> 'edit: conditions'
  tree : =>
    items : [
      module 'tutor/header/button' : {
        title : 'Описание'
        href  : '/tutor/edit/general'
      }
      module 'tutor/header/button' : {
        title : 'Условия'
        href  : '/tutor/edit/subjects'
        tag   : 'edit: conditions'
      }
    ]
    sub_top_menu : state 'tutor/sub_top_menu' :
      items :
        'Предметы'     : 'subjects'
        'Место'        : 'location'
        'Календарь'    : 'calendar'
        'Предпочтения' : 'preferences'
      active_item : 'Предметы'
    content : module '$':
      subject           : module 'tutor/forms/drop_down_list'
      sections          : module 'tutor/forms/drop_down_list'
      destinations      : module 'tutor/forms/drop_down_list'
      category_students : module 'tutor/forms/drop_down_list'
      location          : module 'tutor/forms/drop_down_list'
      price             : module 'tutor/forms/input'
      add_location      : module 'tutor/button' :
        text     : '+'
        selector : 'add_smth'
      pupils_number     : module 'tutor/forms/drop_down_list'
      bet               : module 'tutor/forms/input' :
        text : 'Ставка'
      comments          : module 'tutor/forms/textarea' :
        id     : 'comments'
        height : '82px'
      add_button        : module 'tutor/button' :
        text      : '+Добавить'
        selector  : 'edit_add'
      save_button       : module 'tutor/button' :
          text      : 'Сохранить'
          selector  : 'edit_save'

  init : ->
    @parent.tree.left_menu.setActive 'Анкета'
    @parent.tree.left_menu.setLinks ['../profile', '../search_bids', '#', '#', '#', '#', '#']


