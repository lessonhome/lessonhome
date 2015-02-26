class @main extends template '../../tutor'
  route : '/tutor/search_bids'
  model   : 'tutor/bids/search_bids'
  title : "поиск заявок"
  tags   : -> 'tutor:search_bids'
  tree : =>
    items : [
      module 'tutor/header/button' : {
        title : 'Поиск'
        href  : '/tutor/search_bids'
        tag   : 'tutor:search_bids'
      }
      module 'tutor/header/button' : {
        title : 'Входящие'
        href  : '/tutor/in_bids'
      }
      module 'tutor/header/button' : {
        title : 'Исходящие'
        href  : '/tutor/out_bids'
      }
      module 'tutor/header/button' : {
        title : 'Отчёты'
        href  : '/tutor/reports'
      }
    ]
    content : module '$' :
      advanced_filter : @exports()
      min_height      : @exports()
      subject_list : module 'tutor/forms/drop_down_list' :
        selector : 'search_bids_subject'
      saved_filters : module 'tutor/forms/drop_down_list' :
        selector : 'search_bids'
      tutor : module 'tutor/forms/location_button' :
        selector : 'search_bids'
        text   : 'У себя'
      student  : module 'tutor/forms/location_button' :
        selector : 'search_bids'
        text   : 'У ученика'
      web : module 'tutor/forms/location_button' :
        selector : 'search_bids'
        text   : 'Удалённо'
      location_hint : module 'tutor/hint' :
        selector : 'small'
        field_position : 'left'
        text : 'Одно нажатие кнопки мыши для выбора дня, и двойное нажатие, чтобы ввести точное время для этого дня.'
      address_list : module 'tutor/forms/drop_down_list' :
        selector : 'search_bids'
      save_button  : module 'tutor/button' :
        text     : 'Сохранить'
        selector : 'search_bids_save'

      road_time_slider : state 'main/slider_main' :
        selector      : 'road_time_search_bids'
        start         : 'road_time_search_bids'
        start_text    : 'до'
        measurement   : 'мин.'
        handle        : false

      road_time : module 'tutor/forms/input'

      separate_line : module 'tutor/separate_line' :
        selector : 'horizon'

      list_bids : module 'tutor/bids/list_bids' :
        titles_bid : module '//titles_bid' :
          indent     : false
          number_date   : 'Номер/Дата'
          subject_level : 'Предмет/Уровень'
          place         :'Место'
          city_district : 'Город/Район'
          bet           : 'Ставка'
          price         : 'Цена'
        all_bids : [
          module '//bid' :
            selectable   : false
            number    : 25723
            date      : "10 ноября"
            subject   : 'Физика'
            level     : '6 класс'
            place     : 'У ученика'
            city      : 'Москва'
            district  : 'Бирюлёво'
            bet_price : '1000 руб.'
            bet_time  : '90 мин.'
            price     : '1500 руб.'
            category_pupil      : 'школьники 6-8 классов'
            training_direction  : 'ЕГЭ'
            number_of_lessons   :  'Более 20'
            wishes              : 'Утро выходных дней'
            near_metro          : 'м.Крюково'
            comments            : '-'
            lesson_goal         : 'Устранить пробелы в знаниях'
          module '//bid' :
            selectable   : false
            number    : 15723
            date      : "20 декабря"
            subject   : 'Математика'
            level     : '8 класс'
            place     : 'У ученика'
            city      : 'Москва'
            district  : 'Выхино'
            bet_price : '1000 руб.'
            bet_time  : '90 мин.'
            price     : '1500 руб.'
            category_pupil      : 'школьники 6-8 классов'
            training_direction  : 'ЕГЭ'
            number_of_lessons   :  'Более 20'
            wishes              : 'Утро выходных дней'
            near_metro          : 'м.Крюково'
            comments            : '-'
            lesson_goal         : 'Устранить пробелы в знаниях'
          module '//bid' :
            selectable   : false
            number    : 25723
            date      : "10 ноября"
            subject   : 'Физика'
            level     : '6 класс'
            place     : 'У ученика'
            city      : 'Москва'
            district  : 'Бирюлёво'
            bet_price : '1000 руб.'
            bet_time  : '90 мин.'
            price     : '1500 руб.'
            category_pupil      : 'школьники 6-8 классов'
            training_direction  : 'ЕГЭ'
            number_of_lessons   :  'Более 20'
            wishes              : 'Утро выходных дней'
            near_metro          : 'м.Крюково'
            comments            : '-'
            lesson_goal         : 'Устранить пробелы в знаниях'
          module '//bid' :
            selectable   : false
            number    : 25723
            date      : "10 ноября"
            subject   : 'Физика'
            level     : '6 класс'
            place     : 'У ученика'
            city      : 'Москва'
            district  : 'Бирюлёво'
            bet_price : '1000 руб.'
            bet_time  : '90 мин.'
            price     : '1500 руб.'
            category_pupil      : 'школьники 6-8 классов'
            training_direction  : 'ЕГЭ'
            number_of_lessons   :  'Более 20'
            wishes              : 'Утро выходных дней'
            near_metro          : 'м.Крюково'
            comments            : '-'
            lesson_goal         : 'Устранить пробелы в знаниях'
          module '//bid' :
            selectable   : false
            number    : 25723
            date      : "10 ноября"
            subject   : 'Физика'
            level     : '6 класс'
            place     : 'У ученика'
            city      : 'Москва'
            district  : 'Бирюлёво'
            bet_price : '1000 руб.'
            bet_time  : '90 мин.'
            price     : '1500 руб.'
            category_pupil      : 'школьники 6-8 классов'
            training_direction  : 'ЕГЭ'
            number_of_lessons   :  'Более 20'
            wishes              : 'Утро выходных дней'
            near_metro          : 'м.Крюково'
            comments            : '-'
            lesson_goal         : 'Устранить пробелы в знаниях'
        ]
      courses_list : module 'tutor/forms/drop_down_list'
  init : ->
    @parent.tree.left_menu.setActive 'Заявки'