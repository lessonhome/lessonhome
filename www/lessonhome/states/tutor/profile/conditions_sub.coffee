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
    content : module './conditions' :
      line_place  : module 'tutor/separate_line' :
        title     : 'Место :'
        link      : './edit/location'
        selector  : 'horizon'
      address_time  : module 'tutor/profile/title_block'  :
        name      : 'Новогиреевская улица дом 12 кв 4'
        details   : 'Свободное время'
        selector  : 'title_on_corner'
      map           : module './conditions/map'  :
        srs       : '#'
      show_calendar      : module './conditions/show_calendar'
      outside_work_areas : [          #separate in new module this []
        'Бибирево'
        'Бирюлёво'
        'Крюково'
      ]
      distance_work : [
        'Skype'
        'Viber'
        'Livestream'
      ]
      line_subject  : module 'tutor/separate_line' :
        title     : 'Предметы'
        link      : './edit/subjects'
        selector  : 'horizon'
      subject       : module 'tutor/profile/title_block'  :
        name    : 'Физика :'
        details : 'ЕГЭ, ГИА'
      details_data  : module './conditions/details_data' :
        outside_work_price  : '1500р.'
        home_price          : '1200р.'
        distance_work_price : '900р.'
        subject_data        : module 'tutor/profile/info_block' :
          section :
            'Разделы  :'                    : 'Школьный курс'
            'Категория ученика :'           : 'Школьники 8-11 классов, студенты'
            'Комментарии :'                 : 'Олимпиадные задачи школьного уровня, операционные системы'
            'Групповые занятия :'           : 'до 5 человек, по 1000 р.'
            'Продолжительность :'  : '60-90 минут'
          selector : 'subject_class'
        line_vertical : module 'tutor/separate_line':
          selector  : 'vertical'