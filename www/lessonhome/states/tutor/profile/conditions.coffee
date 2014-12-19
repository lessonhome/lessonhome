
class @main extends template 'tutor/template/template'
  route : '/tutor/conditions'
  model   : 'tutor/conditions'
  title : "условия"
  tree : ->
    content : module 'tutor/profile/conditions' :
      line_place  : module 'tutor/template/separate_line' :
        title     : 'Место :'
        edit      :  true
        selector  : 'horizon'
      address_time  : module 'tutor/profile/title_block'  :
        name      : 'Новогиреевская улица дом 12 кв 4'
        details   : 'Свободное время'
        selector  : 'title_on_corner'                         #variable class in sass
      address_and_free_time: module  'tutor/profile/conditions/map_and_calendar'  :
        map       : '#'
        calendar  : '#'
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
      line_subject  : module 'tutor/template/separate_line' :
        title     : 'Предметы'
        edit      : true
        selector  : 'horizon'
      subject       : module 'tutor/profile/title_block'  :
        name    : 'Физика :'
        details : 'ЕГЭ, ГИА'
      details_data  : module 'tutor/profile/conditions/details_data' :
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
        line_vertical : module 'tutor/template/separate_line':
          selector  : 'vertical'
  init : ->
    @parent.tree.left_menu.setActive 'Анкета'
    @parent.tree.header.top_menu.active_item = 'Условия'



