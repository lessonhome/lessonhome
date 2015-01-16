class @main extends template '../tutor'
  route : '/tutor/profile'
  model   : 'tutor/profile/profile'
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
      all_rating  : module '../all_rating':
        filling  : '40'
      progress  : module '$/progress' :
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
        link      : './edit/contacts'
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
        link      : './edit/education'
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
        link      : './edit/about'
        edit      : true
        selector  : 'horizon'
      private : module '$/private' :
        text : 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut laLorem ipsum dolor sit amet, consectetur adipisicing elit'
      line_med : module 'tutor/separate_line':
        title    : 'Медиа'
        link      : './edit/media'
        edit     : true
        selector : 'horizon'
      media : module '$/media' :
        photo1  : module 'mime/photo' :
          src : 'http://cs10490.vk.me/u168292091/a_fc7a117a.jpg'
        photo2  : module 'mime/photo' :
          src : 'http://cs10490.vk.me/u168292091/a_fc7a117a.jpg'
        video   : module 'mime/video' :
          src : 'http://cs10490.vk.me/u168292091/a_fc7a117a.jpg'
  init : ->
    @parent.tree.left_menu.setActive 'Анкета'

