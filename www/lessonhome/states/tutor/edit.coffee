class @main extends template '../tutor'
  tags : -> 'edit: conditions'
  tree : =>
    items : [
      module 'tutor/header/button' : {
        title : 'Описание'
        href  : '/tutor/edit/general'
        tag   : @exports 'menu_description'
      }
      module 'tutor/header/button' : {
        title : 'Условия'
        href  : '/tutor/edit/subjects'
        tag   : @exports 'menu_condition'
      }
    ]
    sub_top_menu : state 'tutor/sub_top_menu' :
      items       : @exports()
      active_item : @exports()
    content : module '$' :
      title       : @exports()
      tutor_edit  : @exports()
      hint        : @exports()
      save_button       : module 'tutor/button' :
        text      : 'Сохранить'
        selector  : 'edit_save'