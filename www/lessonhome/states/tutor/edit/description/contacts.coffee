@route = '/tutor/edit/contacts'

@struct = state 'tutor/template/template'

@struct.header.top_menu.items =
  'Описание'           : '#'
  'Предметы и условия' : 'subjects'

@struct.header.top_menu.active_item = 'Описание'

@struct.sub_top_menu = state 'tutor/template/sub_top_menu'

@struct.sub_top_menu.items =
  'Общие'       : 'general'
  'Контакты'    : 'contacts'
  'Образование' : 'education'
  'Карьера'     : 'career'
  'О себе'      : 'about'
  'Медиа'       : 'media'

@struct.sub_top_menu?.active_item = 'Контакты'


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

@struct.content = module 'tutor/edit/description/contacts' :

  country : module 'tutor/template/forms/drop_down_list' :
    width : @struct.vars.input_width1

  city : module 'tutor/template/forms/drop_down_list' :
    width : @struct.vars.input_width1

  address_button : module 'tutor/template/button' :
    type  : 'fixed'
    text  : 'Укажите место'

  mobile_phone     : module 'tutor/template/forms/input' :
    width : @struct.vars.input_width1

  additional_phone : module 'tutor/template/forms/input' :
    width : @struct.vars.input_width1

  mail  : module 'tutor/template/forms/input' :
    width : @struct.vars.input_width1

  skype : module 'tutor/template/forms/input' :
    width : @struct.vars.input_width1

  personal_website : module 'tutor/template/forms/input' :
    width : @struct.vars.input_width1

  save_button : module 'tutor/template/button' :
    text  : 'Сохранить'
    type  : 'fixed'


  hint : module 'tutor/template/hint' :
    type : 'horizontal'
    header : 'Это подсказка'
    text : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит. Однако в некоторых исключительных случаях зависимость какой-либо величины от времени может оказаться пренебрежимо слабой, так что с высокой точностью можно считать эту характеристику независящей от времени. Если такие величины описывают динамику какой-либо системы,'