class @main extends template 'tutor/template/template'
  route : '/tutor/edit/media'
  model   : 'tutor/edit/media'
  title : "редактирование медиа"
  tree : =>
    items : [
      module 'tutor/template/header/button' : {
        title : 'Описание'
        href  : '/tutor/edit/general'
      }
      module 'tutor/template/header/button' : {
        title : 'Условия'
        href  : '/tutor/edit/subjects'
      }
    ]
    sub_top_menu : state 'tutor/template/sub_top_menu' :
      items :
        'Общие'       : 'general'
        'Контакты'    : 'contacts'
        'Образование' : 'education'
        'Карьера'     : 'career'
        'О себе'      : 'about'
        'Медиа'       : 'media'
      active_item : 'Медиа'
    content :  module 'tutor/edit/description/media':

      photos : [

        module 'mime/photo' :
          src : '#'

        module 'mime/photo' :
          src : '#'

        module 'mime/photo' :
          src : '#'

        module 'mime/photo' :
          src : '#'
      ]
      videos : [
        module 'mime/video' :
          src : '#'

        module 'mime/video' :
          src : '#'
      ]

      number_of_photos : 4
      number_of_videos : 2

      add_photos : module 'tutor/template/button' :
        text      : '+ Добавить'
        selector  : 'color_blue'

      add_videos : module 'tutor/template/button' :
        text      : '+ Добавить'
        selector  : 'fixed'


      hint : module 'tutor/template/hint' :
        type : 'horizontal'
        header : 'Это подсказка'
        text : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит. Однако в некоторых исключительных случаях зависимость какой-либо величины от времени может оказаться пренебрежимо слабой, так что с высокой точностью можно считать эту характеристику независящей от времени. Если такие величины описывают динамику какой-либо системы,'


  init : ->
    @parent.tree.left_menu.setActive 'Анкета'
    @parent.tree.left_menu.setLinks ['../profile', '../search_bids', '#', '#', '#', '#', '#']
