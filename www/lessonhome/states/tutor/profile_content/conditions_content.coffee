class @main
  tree : -> module '$' :
    line_place  : module 'tutor/separate_line' :
      title     : 'Место :'
      link      : './edit/location'
      edit      :  @exports()
      selector  : 'horizon'
    address_time  : module 'tutor/profile_content/title_block'  :
      title     : 'Даниловский'
      title_two   : 'Свободное время'
      selector  : 'address_time'                         #variable class in sass
    map           : module '$/map'  :
      srs       : '#'
    show_calendar      : module '$/show_calendar' :
      day_time : [
        {
          day       : 'пн :'
          from_time : '12:00'
          to_time   : '16:00'
        }
        {
          day       : 'вт :'
          from_time : '12:00'
          to_time   : '6:00'
        }
        {
          day       : 'ср :'
          from_time : '12:00'
          to_time   : '16:00'
        }
        {
          day       : 'чт :'
          from_time : '12:00'
          to_time   : '16:00'
        }
        {
          day       : 'пт :'
          from_time : '12:00'
          to_time   : '16:00'
        }
        {
          day       : 'пт :'
          from_time : '12:00'
          to_time   : '16:00'
        }
      ]
      separate_line       : module '../separate_line'  :
        selector  : 'calendar'
    outside_work_areas  : [
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
      edit      :  @exports()
      selector  : 'horizon'
    subject       : module 'tutor/profile_content/title_block'  :
      title     : 'Физика :'
      details   : 'ЕГЭ, ГИА'
      selector  : 'subject'
    details_data  : module '$/details_data' :
      outside_work_price  : '1500р.'
      home_price          : '1200р.'
      distance_work_price : '900р.'
      subject_data        : module 'tutor/profile_content/info_block' :
        section :
          'Категория ученика :'           : 'Школьники 8-11 классов, студенты'
          'Комментарии :'                 : 'Олимпиадные задачи школьного уровня, операционные системы'
          'Групповые занятия :'           : 'до 5 человек, по 1000 р.'
          'Продолжительность :'           : '60-90 минут'
        selector : 'subject_class'
        line_horizon  :  module 'tutor/separate_line' :
          selector  : 'horizon'
      line_vertical : module 'tutor/separate_line':
        selector  : 'vertical'