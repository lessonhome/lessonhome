@route = '/tutor/edit/about'

@struct = state 'tutor/template/template'
#
@struct.header.top_menu.items =
  'Описание'           : 'general'
  'Предметы и условия' : 'subjects'

@struct.header.top_menu.active_item = 'Описание'

@struct.sub_top_menu = state 'tutor/template/sub_top_menu'

@struct.sub_top_menu.items =
  'Общие'       : 'general'
  'Контакты'    : 'contacts'
  'Образование' : '#'
  'Карьера'     : 'career'
  'О себе'      : 'about'
  'Медиа'       : 'media'

@struct.sub_top_menu?.active_item = 'О себе'

@left_menu_href = ['../profile', '../bids', '#', '#', '#', '#', '#']
for href,i in @left_menu_href
  @struct.left_menu.items[i].href = href

@struct.left_menu.setActive.call(@struct.left_menu,'Анкета')

@struct.content = module 'tutor/edit/description/about' :
  reason_textarea : module 'tutor/template/forms/textarea' :
    id     : 'reason'
    width  : '460px'
    height : '87px'

  interests_textarea : module 'tutor/template/forms/textarea' :
    id     : 'interests'
    width  : '460px'
    height : '87px'

  about_textarea : module 'tutor/template/forms/textarea' :
    id     : 'about'
    width  : '460px'
    height : '87px'

  hint : module 'tutor/template/hint' :
    type : 'horizontal'
    header : 'Это подсказка'
    text : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит. Однако в некоторых исключительных случаях зависимость какой-либо величины от времени может оказаться пренебрежимо слабой, так что с высокой точностью можно считать эту характеристику независящей от времени. Если такие величины описывают динамику какой-либо системы,'

  button : module 'tutor/template/button' :
    text  : 'Сохранить'
    type : 'fixed'


