
class @main extends template 'tutor/template/template'
  route : '/tutor/edit/education'
  model   : 'tutor/edit/education'
  title : "редактирование образования"
  tree : ->
    sub_top_menu : state 'tutor/template/sub_top_menu' :
      items :
        'Общие'       : 'general'
        'Контакты'    : 'contacts'
        'Образование' : 'education'
        'Карьера'     : 'career'
        'О себе'      : 'about'
        'Медиа'       : 'media'
      active_item : 'Образование'

    content : module 'tutor/edit/description/education' :
      country       : module 'tutor/template/forms/drop_down_list'
      city          : module 'tutor/template/forms/drop_down_list'
      university    : module 'tutor/template/forms/drop_down_list'
      faculty       : module 'tutor/template/forms/input'
      chair         : module 'tutor/template/forms/drop_down_list'
      status        : module 'tutor/template/forms/drop_down_list'
      release_day   : module 'tutor/template/forms/drop_down_list'
      release_month : module 'tutor/template/forms/drop_down_list'
      release_year  : module 'tutor/template/forms/drop_down_list'
      add_button    : module 'tutor/template/button' :
        text      : '+ Добавить'
        selector  : 'fixed'
      save_button   : module 'tutor/template/button' :
        text      : 'Сохранить'
        selector  : 'fixed'
      hint          : module 'tutor/template/hint' :
        selector  : 'horizontal'
        header    : 'Это подсказка'
        text      : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени,
                   как обычно и происходит. Однако в некоторых исключительных случаях зависимость какой-либо величины от времени может оказаться пренебрежимо слабой,
                   так что с высокой точностью можно считать эту характеристику независящей от времени. Если такие величины описывают динамику какой-либо системы,'

  init : ->
    @parent.setTopMenu 'Описание', {
      'Описание': 'general'
      'Условия' : 'subjects'
    }

    @parent.tree.left_menu.setActive 'Анкета'
    @parent.tree.left_menu.setLinks ['../profile', '../bids', '#', '#', '#', '#', '#']






