class @main
  forms : [{'tutor':['calendar', 'subject'], person:['location', 'address', 'area']}]
  tree : -> module '$' :
    line_place  : module 'tutor/separate_line' :
      title     : 'Место :'
      link      : './edit/location'
      edit      :  @exports()
      selector  : 'horizon'
    address_time  : module 'tutor/profile_content/title_block'  :
      title     :  $form : person : 'area'
      title_two   : 'Свободное время'
      selector  : 'address_time'                         #variable class in sass
    map : module 'maps/yandex'
    address : $form : person : 'address'                 # in pair with map
    show_calendar      : module '$/show_calendar' :
      day_time : $form : tutor : 'calendar'
      separate_line       : module '../separate_line'  :
        selector  : 'calendar'
    outside_work_areas  : $form : tutor : 'check_out_the_areas'
    line_subject  : module 'tutor/separate_line' :
      title     : 'Предметы'
      link      : './edit/subjects'
      edit      :  @exports()
      selector  : 'horizon'
    subject       : module 'tutor/profile_content/title_block'  :
      title     : $form : tutor : 'subject.name'
      details   : $form : tutor : 'subject.tags.0'
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