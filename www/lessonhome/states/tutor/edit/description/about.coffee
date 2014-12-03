
class @main extends template 'tutor/template/template'
  route : '/tutor/edit/about'
  tree : ->
    sub_top_menu : state 'tutor/template/sub_top_menu' :
      items :
        'Общие'       : 'general'
        'Контакты'    : 'contacts'
        'Образование' : 'education'
        'Карьера'     : 'career'
        'О себе'      : 'about'
        'Медиа'       : 'media'
      active_item : 'О себе'
    content : module 'tutor/edit/description/about' :
      reason_textarea : module 'tutor/template/forms/textarea' :
        height : '87px'
      interests_textarea : module 'tutor/template/forms/textarea' :
        height : '87px'
      about_textarea : module 'tutor/template/forms/textarea' :
        height : '87px'
      hint : module 'tutor/template/hint' :
        type : 'horizontal'
        header : 'Это подсказка'
        text : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит. Однако в некоторых исключительных случаях зависимость какой-либо величины от времени может оказаться пренебрежимо слабой, так что с высокой точностью можно считать эту характеристику независящей от времени. Если такие величины описывают динамику какой-либо системы,'
      button : module 'tutor/template/button' :
        text  : 'Сохранить'
        type : 'fixed'
  init : ->
    @parent.tree.header.top_menu.active_item = 'Описание'
    @parent.tree.header.top_menu.items =
      'Описание'  : 'general'
      'Условия'   : 'subjects'

    left_menu_href = ['../profile', '../bids', '#', '#', '#', '#', '#']
    for href,i in left_menu_href
      @parent.tree.left_menu.items[i].href = href

    @parent.tree.left_menu.setActive 'Анкета'
