class @main extends template '../../../tutor'
  route : '/tutor/edit/education'
  model   : 'tutor/edit/description/education'
  title : "редактирование образования"
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
        'Настройки'   : 'settings'
        'Общие'       : 'general'
        'Контакты'    : 'contacts'
        'Образование' : 'education'
        'Карьера'     : 'career'
        'О себе'      : 'about'
        #'Медиа'       : 'media'
      active_item : 'Образование'

    content : module '$' :
      country       : module 'tutor/forms/drop_down_list'
      city          : module 'tutor/forms/drop_down_list'
      university    : module 'tutor/forms/drop_down_list'
      faculty       : module 'tutor/forms/input'
      chair         : module 'tutor/forms/drop_down_list'
      status        : module 'tutor/forms/drop_down_list'
      release_day   : module 'tutor/forms/drop_down_list' :
        placeholder : 'День'
      release_month : module 'tutor/forms/drop_down_list' :
        placeholder : 'Месяц'
      release_year  : module 'tutor/forms/drop_down_list' :
        placeholder : 'Год'
      add_button    : module 'tutor/button' :
        text      : '+Добавить'
        selector  : 'edit_add'
      save_button   : module 'tutor/button' :
        text      : 'Сохранить'
        selector  : 'edit_save'
      hint          : module 'tutor/hint' :
        selector  : 'horizontal'
        header    : 'Это подсказка'
        text      : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени,
                   как обычно и происходит. Однако в некоторых исключительных случаях'

  init : ->
    @parent.tree.left_menu.setActive 'Анкета'
    @parent.tree.left_menu.setLinks ['../profile', '../search_bids', '#', '#', '#', '#', '#']






