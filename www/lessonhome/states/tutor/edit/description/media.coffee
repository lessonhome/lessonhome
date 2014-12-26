###
  class @main extends template '../../../tutor'
    route : '/tutor/edit/media'
    model   : 'tutor/edit/description/media'
    title : "редактирование медиа"
    tree : =>
      items : [
        module 'tutor/header/button' : {
          title : 'Описание'
          href  : '/tutor/edit/general'
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
          'Медиа'       : 'media'
        active_item : 'Медиа'
      content :  module '$':

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

        add_photos : module '//add_button' :
          selector  : 'photo'

        add_videos : module '//add_button' :
          selector  : 'video'


        hint : module 'tutor/hint' :
          type : 'horizontal'
          header : 'Это подсказка'
          text : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит. Однако в некоторых исключительных случаях зависимость какой-либо величины от времени может оказаться пренебрежимо слабой, так что с высокой точностью можно считать эту характеристику независящей от времени. Если такие величины описывают динамику какой-либо системы,'


    init : ->
      @parent.tree.left_menu.setActive 'Анкета'
      @parent.tree.left_menu.setLinks ['../profile', '../search_bids', '#', '#', '#', '#', '#']

###