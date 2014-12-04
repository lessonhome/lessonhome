
class @main extends template 'tutor/template/template'
  route : '/tutor/edit/education'
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
      country : module 'tutor/template/forms/drop_down_list'
      city : module 'tutor/template/forms/drop_down_list'
      university : module 'tutor/template/forms/drop_down_list'
      faculty : module 'tutor/template/forms/input'
      chair : module 'tutor/template/forms/drop_down_list'
      status : module 'tutor/template/forms/drop_down_list'
      release_day : module 'tutor/template/forms/drop_down_list'
      release_month : module 'tutor/template/forms/drop_down_list'
      release_year : module 'tutor/template/forms/drop_down_list'
      add_button : module 'tutor/template/button' :
        text  : '+ Добавить'
        type  : 'fixed'
      save_button : module 'tutor/template/button' :
        text  : 'Сохранить'
        type  : 'fixed'
      hint : module 'tutor/template/hint' :
        type : 'horizontal'
        header : 'Это подсказка'
        text : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени,
                   как обычно и происходит. Однако в некоторых исключительных случаях зависимость какой-либо величины от времени может оказаться пренебрежимо слабой,
                   так что с высокой точностью можно считать эту характеристику независящей от времени. Если такие величины описывают динамику какой-либо системы,'

  init : ->
    @parent.tree.header.top_menu.active_item = 'Описание'
    @parent.tree.header.top_menu.items =
      'Описание'  : 'general'
      'Условия'   : 'subjects'

    left_menu_href = ['../profile', '../bids', '#', '#', '#', '#', '#']
    for href,i in left_menu_href
      @parent.tree.left_menu.items[i].href = href

    @parent.tree.left_menu.setActive 'Анкета'

    for key,val of @tree.content
      if key<7
        val.width = @parent.tree.vars.input_width1
      else
        val.width = @parent.tree.vars.input_width3




