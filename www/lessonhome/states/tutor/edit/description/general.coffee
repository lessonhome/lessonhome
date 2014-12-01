@route = '/tutor/edit/general'

@struct = state 'tutor/template/template'

@struct.header.top_menu.items =
  'Описание'           : 'general'
  'Условия' : 'subjects'

@struct.header.top_menu.active_item = 'Описание'

@struct.sub_top_menu = state 'tutor/template/sub_top_menu'

@struct.sub_top_menu.items =
  'Общие'       : 'general'
  'Контакты'    : 'contacts'
  'Образование' : 'education'
  'Карьера'     : 'career'
  'О себе'      : 'about'
  'Медиа'       : 'media'

@struct.sub_top_menu?.active_item = 'Общие'

@left_menu_href = ['../profile', '../bids', '#', '#', '#', '#', '#']
for href,i in @left_menu_href
  @struct.left_menu.items[i].href = href

@struct.left_menu.setActive.call(@struct.left_menu,'Анкета')


@struct.content = module 'tutor/edit/description/general' :

  first_name : module 'tutor/template/forms/input' :
    width  : '335px'

  second_name : module 'tutor/template/forms/input' :
    width  : '335px'

  patronymic : module 'tutor/template/forms/input' :
    width  : '335px'

  sex :
    width  : '335px'
    male   : module 'tutor/template/button' :
      text : 'М'
      type : 'fixed'

    female : module 'tutor/template/button' :
      text : 'Ж'
      type : 'fixed'

  birth_day   : module 'tutor/template/forms/drop_down_list' :
    width : @struct.vars.input_width3

  birth_month : module 'tutor/template/forms/drop_down_list' :
    width : @struct.vars.input_width3

  birth_year  : module 'tutor/template/forms/drop_down_list' :
    width : @struct.vars.input_width3

  status :  module 'tutor/template/forms/drop_down_list' :
    width : @struct.vars.input_width1

  save_button : module 'tutor/template/button' :
    text  : 'Сохранить'
    type  : 'fixed'

  hint : module 'tutor/template/hint' :
    type   : 'horizontal'
    header : 'Это подсказка'
    text   : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит. Однако в некоторых исключительных случаях зависимость какой-либо величины от времени может оказаться пренебрежимо слабой, так что с высокой точностью можно считать эту характеристику независящей от времени. Если такие величины описывают динамику какой-либо системы,'
