class @main extends template '../../../tutor'
  route : '/tutor/edit/about'
  model   : 'tutor/edit/description/about'
  title : "редактирование о себе"
  tags : -> 'edit: description'
  tree : =>
    items : [
      module 'tutor/header/button' : {
        title : 'Описание'
        href  : '/tutor/edit/general'
        tag   : 'edit: description'
      }
      module 'tutor/header/button' : {
        title : 'Условия'
        href  : '/tutor/edit/subjects'
      }
    ]
    sub_top_menu : state 'tutor/sub_top_menu' :
      items :
        'Общие'       : 'general'
        'Контакты'    : 'contacts'
        'Образование' : 'education'
        'Карьера'     : 'career'
        'О себе'      : 'about'
        'Настройки'   : 'settings'
        #'Медиа'       : 'media'
      active_item : 'О себе'

    content : module '$' :
      reason_textarea     : module 'tutor/forms/textarea' :
        height    : '87px'
      interests_textarea  : module 'tutor/forms/textarea' :
        height    : '87px'
      about_textarea      : module 'tutor/forms/textarea' :
        height    : '117px'
      hint                : module 'tutor/hint' :
        selector  : 'horizontal'
        header    : 'Это подсказка'
        text      : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени,
               как обычно и происходит. Однако в некоторых исключительных случаях зависимость какой-либо величины от времени может оказаться пренебрежимо слабой,
                так что с высокой точностью можно считать эту характеристику независящей от времени. Если такие величины описывают динамику какой-либо системы,'
      button              : module 'tutor/button' :
        text      : 'Сохранить'
        selector  : 'edit_save'
  init : ->
    @parent.tree.left_menu.setActive 'Анкета'
    @parent.tree.left_menu.setLinks ['../profile', '../search_bids', '#', '#', '#', '#', '#']
