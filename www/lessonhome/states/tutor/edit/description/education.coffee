@route = '/tutor/edit/education'

@struct = state 'tutor/template/template'

@struct.header.top_menu.items =
  'Описание'           : '#'
  'Предметы и условия' : 'subjects'

@struct.header.top_menu.active_item = 'Описание'

@struct.sub_top_menu = state 'tutor/template/sub_top_menu'

@struct.sub_top_menu.items =
  'Общие'       : '#'
  'Контакты'    : 'contacts'
  'Образование' : 'education'
  'Карьера'     : 'career'
  'О себе'      : 'about'
  'Медиа'       : 'media'

@struct.sub_top_menu?.active_item = 'Образование'


@struct.left_menu.items = {
  'Анкета': '../profile'
  'Заявки': '../bids'
  'Оплата': '#'
  'Документы': '#'
  'Форум': '#'
  'Статьи': '#'
  'Поддержка': '#'
}

@struct.left_menu.active_item = 'Анкета'

@struct.content = module 'tutor/edit/description/education' :
  country : module 'tutor/template/forms/drop_down_list' :
    width : @struct.vars.input_width1

  city : module 'tutor/template/forms/drop_down_list' :
    width : @struct.vars.input_width1

  university : module 'tutor/template/forms/drop_down_list' :
    width : @struct.vars.input_width1

  faculty : module 'tutor/template/forms/input' :
    width : @struct.vars.input_width1

  chair : module 'tutor/template/forms/drop_down_list' :
    width : @struct.vars.input_width1

  status : module 'tutor/template/forms/drop_down_list' :
    width : @struct.vars.input_width1

  release_day : module 'tutor/template/forms/drop_down_list' :
    width : @struct.vars.input_width3

  release_month : module 'tutor/template/forms/drop_down_list' :
    width : @struct.vars.input_width3

  release_year : module 'tutor/template/forms/drop_down_list' :
    width : @struct.vars.input_width3

  add_button : module 'tutor/template/button' :
    text  : '+ Добавить'
    type  : 'fixed'

  save_button : module 'tutor/template/button' :
    text  : 'Сохранить'
    type  : 'fixed'

  hint : module 'tutor/template/hint' :
    type : 'horizontal'
    header : 'Это подсказка'
    text : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит. Однако в некоторых исключительных случаях зависимость какой-либо величины от времени может оказаться пренебрежимо слабой, так что с высокой точностью можно считать эту характеристику независящей от времени. Если такие величины описывают динамику какой-либо системы,'