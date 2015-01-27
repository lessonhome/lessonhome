class @main
  tree : ->
    items : [
      module 'tutor/header/button' : {
        href  : '/second_step_popup_profile'
        title : "Анкета"
      }
      module 'tutor/header/button' : {
        href  : '/second_step_popup_conditions'
        title : "Условия"
      }
      module 'tutor/header/button' : {
        href  : '/second_step_popup_reviews'
        title : "Отзывы"
      }
    ]
    content : module 'tutor/profile'  :
      send_bid_this_tutor : module '../button'  :
        text      : 'Отправить заявку<br>только этому<br>репетитору'
        selector  : 'send_bid_this_tutor'
      with_verification : 'rgb(183, 210, 120)'
      photo         : module 'mime/photo' :
        src : 'http://cs10490.vk.me/u168292091/a_fc7a117a.jpg'
      all_rating    : module 'rating_star':
        filling : 40
      count_review  : 10

      name          : 'Иванов Иван Иванович'
      personal_data : module './info_block' :
        section   :
          'Дата рождения :'       : '11.11.11'
          'Статус :'              : 'Профессор'
          'Город :'               : 'Москва'
          'Опыт репетиторства :'  : '2 года'
          'Количество учеников :' : '5'
          'Место работы :'        : 'Кооператив сосулька'
      line_edu      : module 'tutor/separate_line':
        title     : 'Образование'
        selector  : 'horizon'
      education   : module './info_block' :
        section :
          'ВУЗ :'           : 'МГУ'
          'Город :'         : 'Москва'
          'Фаультет :'      : 'Географический'
          'Кафедра :'       : 'Экономической географии'
          'Статус :'        : 'Специалист'
          'Год выпуска:'    : '2011'
      line_pri    : module 'tutor/separate_line':
        title     : 'О себе'
        selector  : 'horizon'
      private   : module './private' :
        text : 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut laLorem ipsum dolor sit amet, consectetur adipisicing elit'
      line_med  : module 'tutor/separate_line':
        title    : 'Медиа'
        selector : 'horizon'
      media     : module './media' :
        photo1  : module 'mime/photo' :
          src : 'http://cs10490.vk.me/u168292091/a_fc7a117a.jpg'
        photo2  : module 'mime/photo' :
          src : 'http://cs10490.vk.me/u168292091/a_fc7a117a.jpg'
        video   : module 'mime/video' :
          src : 'http://cs10490.vk.me/u168292091/a_fc7a117a.jpg'