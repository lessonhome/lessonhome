class @main extends template '../../../tutor'
  route : '/tutor/edit/contacts'
  model   : 'tutor/edit/description/contacts'
  title : "редактирование контактов"
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
      active_item : 'Контакты'
    content : module '$' :
      country         : module 'tutor/forms/drop_down_list'
      city            : module 'tutor/forms/drop_down_list'
      location_button : module '//location_button'
      line : module 'tutor/separate_line' :
        selector : 'gradient'
      mobile_phone      : module 'tutor/forms/input'
      additional_phone  : module 'tutor/forms/input'
      mail              : module 'tutor/forms/input'
      skype             : module 'tutor/forms/input'
      personal_website  : module 'tutor/forms/input'
      save_button       : module 'tutor/button' :
        text      : 'Сохранить'
        selector  : 'edit_save'
      hint : module 'tutor/hint' :
        selector  : 'horizontal'
        header    : 'Это подсказка'
        text      : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит. Однако в некоторых исключительных случаях зависимость какой-либо величины от времени может оказаться пренебрежимо слабой, так что с высокой точностью можно считать эту характеристику независящей от времени. Если такие величины описывают динамику какой-либо системы,'
  init : ->
    @parent.tree.left_menu.setActive 'Анкета'
    @parent.tree.left_menu.setLinks ['../profile', '../search_bids', '#', '#', '#', '#', '#']


