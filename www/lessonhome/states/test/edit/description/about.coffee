class @main extends template 'test/template/template'
  route : '/ololo'
  title : 'ololo'
  tree  : ->
    sub_top_menu : state '../../template/sub_top_menu' :
      items :
        'Общие'       : 'general'
        'Контакты'    : 'contacts'
        'Образование' : '#'
        'Карьера'     : 'career'
        'О себе'      : 'about'
        'Медиа'       : 'media'
      active_item : 'О себе'
    content : module 'tutor/edit/description/about' :
      reason_textarea : module 'tutor/template/forms/textarea' :
        id     : 'reason'
        width  : '455px'
        height : '82px'

      interests_textarea : module 'tutor/template/forms/textarea' :
        id     : 'interests'
        width  : '455px'
        height : '82px'

      about_textarea : module 'tutor/template/forms/textarea' :
        id     : 'about'
        width  : '455px'
        height : '82px'

      hint : module 'tutor/template/hint' :
        selector  : 'horizontal'
        header    : 'Это подсказка'
        text      : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит. Однако в некоторых исключительных случаях зависимость какой-либо величины от времени может оказаться пренебрежимо слабой, так что с высокой точностью можно считать эту характеристику независящей от времени. Если такие величины описывают динамику какой-либо системы,'

      button : module 'tutor/template/button' :
        text      : 'Сохранить'
        selector  : 'fixed'
      
  init : ->
    @parent.tree.header.top_menu.items =
      'Описание'           : 'general'
      'Предметы и условия' : 'subjects'
    @parent.tree.header.top_menu.active_item = 'Описание'
    ###@parent.tree.left_menu.items =
      'Анкета': '../profile'
      'Заявки': '../bids'
      'Оплата': '#'
      'Документы': '#'
      'Форум': '#'
      'Статьи': '#'
      'Поддержка': '#'
    @parent.tree.left_menu.active_item = 'Анкета'
    ###
  run  : ->

