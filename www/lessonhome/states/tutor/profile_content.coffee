class @main
  tree : -> module '$'  :
    popup               : @exports()
    photo               : module 'mime/photo' :
      src      : 'http://cs10490.vk.me/u168292091/a_fc7a117a.jpg'
    all_rating          : module '../rating_star':
      filling  : 40
    progress            : @exports()
    count_review        : @exports()
    send_bid_this_tutor : @exports()
    tutor_name                : 'Иванов Иван Иванович'
    with_verification   : true
    personal_data       : module '$/info_block' :
      section   :
        'Дата рождения :'       : '11.11.2011'
        'Статус :'              : 'Профессор'
        'Город :'               : 'Москва'
        'Опыт репетиторства :'  : '2 года'
        'Количество учеников :' : 5
        'Место работы :'        : 'Кооператив сосулька'
    line_con            : module 'tutor/separate_line':
      title     : 'Контакты'
      link      : './edit/contacts'
      edit      : @exports()
      selector  : 'horizon'
    contacts : @exports()
    line_edu            : module 'tutor/separate_line':
      title     : 'Образование'
      link      : './edit/education'
      edit      : @exports()
      selector  : 'horizon'
    education           : module '$/info_block' :
      section :
        'ВУЗ :'         : 'МГУ'
        'Город :'       : 'Москва'
        'Фаультет :'    : 'Географический'
        'Кафедра :'     : 'Экономической географии'
        'Статус :'      : 'Специалист'
        'Год выпуска:'  : 2011
    line_pri            : module 'tutor/separate_line':
      title     : 'О себе'
      link      : './edit/about'
      edit      : @exports()
      selector  : 'horizon'
    private             : module '$/private' :
      text : 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut laLorem ipsum dolor sit amet, consectetur adipisicing elit'
    line_med            : module 'tutor/separate_line':
      title    : 'Медиа'
      link      : './edit/media'
      edit     : @exports()
      selector : 'horizon'
    media               : module '$/media' :
      photo1  : module 'mime/photo' :
        src : 'http://cs10490.vk.me/u168292091/a_fc7a117a.jpg'
      photo2  : module 'mime/photo' :
        src : 'http://cs10490.vk.me/u168292091/a_fc7a117a.jpg'
      video   : module 'mime/video' :
        src : 'http://cs10490.vk.me/u168292091/a_fc7a117a.jpg'