class @main extends template '../tutor'
  route : '/tutor/profile'
  model   : 'tutor/profile'
  title : "анкета"
  tree : ->
    items : [
      module 'tutor/header/button' : {
        title : 'Описание'
        href  : '/tutor/profile'
      }
      module 'tutor/header/button' : {
        title : 'Условия'
        href  : '/tutor/conditions'
      }
      module 'tutor/header/button' : {
        title : 'Отзывы'
        href  : '/tutor/reviews'
      }
    ]
    content : module '$'  :
      popup         : @exports()
      photo         : module 'mime/photo' :
        src      : 'http://cs10490.vk.me/u168292091/a_fc7a117a.jpg'
      progress  : module '$/description/progress' :
        filling  : '56%'
      name          : 'Артемий Дудко'
      personal_data : module '$/info_block' :
        section   :
          'Дата рождения :'       : '11.11.11'
          'Статус :'              : 'Профессор'
          'Город :'               : 'Москва'
          'Опыт репетиторства :'  : '2 года'
          'Количество учеников :' : '5'
          'Место работы :'        : 'Кооператив сосулька'
      line_con : module 'tutor/separate_line':
        title     : 'Контакты'
        edit      : true
        selector  : 'horizon'
      contacts : module '$/info_block' :
        section :
          'Телефон :'     : '11.11.11'
          'Почта :'       : 'yandex@rambler.ru'
          'Скап :'        : 'baklane'
          'Личный сайт :' : 'prepod.ru'
      line_edu : module 'tutor/separate_line':
        title     : 'Образование'
        edit      : true
        selector  : 'horizon'
      education : module '$/info_block' :
        section :
          'ВУЗ :'           : 'МГУ'
          'Город :'         : 'Москва'
          'Фаультет :'      : 'Географический'
          'Кафедра :'       : 'Экономической географии'
          'Статус :'        : 'Специалист'
          'Год выпуска:'    : '2011'
      line_pri    : module 'tutor/separate_line':
        title     : 'О себе'
        edit      : true
        selector  : 'horizon'
      private : module '$/description/private' :
        text : 'О себеО себеО себеО себеО себеО себеО себеО себеО себе
            О себеО себеО себеО себеО себеО себеО себеО себеО себеО себеО
            О себеО себеО себеО себеО себеО себеО себеО себеО себеО себе:'
      line_med : module 'tutor/separate_line':
        title    : 'Медиа'
        edit     : true
        selector : 'horizon'
      media : module '$/description/media' :
        photo1  : module 'mime/photo' :
          src : 'http://cs10490.vk.me/u168292091/a_fc7a117a.jpg'
        photo2  : module 'mime/photo' :
          src : 'http://cs10490.vk.me/u168292091/a_fc7a117a.jpg'
        video   : module 'mime/video' :
          src : 'http://cs10490.vk.me/u168292091/a_fc7a117a.jpg'
  init : ->
    @parent.tree.left_menu.setActive 'Анкета'
