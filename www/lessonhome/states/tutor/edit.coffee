class @main extends template '../tutor'
  tree : =>
    items : [
      module 'tutor/header/button' :
        title : 'Описание'
        href  : '/tutor/edit/general'
        tag   : @exports 'menu_description'
      module 'tutor/header/button' :
        title : 'Условия'
        href  : '/tutor/edit/subjects'
        tag   : @exports 'menu_condition'
    ]
    sub_top_menu : state 'tutor/sub_top_menu' :
      items       : @exports()
      active_item : @exports()
    content : module '$' :
      changes_field : module '//changes_field'
      tutor_edit    : @exports()                    # this property responds for content
      hint          : @exports()                    # this property responds for hint
      save_button       : module 'tutor/button' :
        text      : 'Сохранить'
        selector  : 'edit_save'
      possibility_save_button :  true               # this property responds for save button
  init : ->
    @parent.tree.left_menu.setActive 'Анкета'
    @parent.tree.left_menu.setLinks ['../profile', '../search_bids', '#', '#', '#', '#', '#']