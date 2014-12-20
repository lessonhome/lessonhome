@route = '/tutor/search_bids'

class @main extends template 'tutor/template/template'
  route : '/tutor/search_bids'
  model   : 'tutor/search_bids'
  title : "поиск заявок"
  tree : ->
    items : [
      module 'tutor/template/header/button' : {
        title : 'Поиск'
        href  : '/tutor/search_bids'
      }
      module 'tutor/template/header/button' : {
        title : 'Входящие'
        href  : '/tutor/in_bids'
      }
      module 'tutor/template/header/button' : {
        title : 'Исходящие'
        href  : '/tutor/out_bids'
      }
      module 'tutor/template/header/button' : {
        title : 'Отчёты'
        href  : '/tutor/reports'
      }
    ]
    content : module 'tutor/bids/search_bids' :
      subject_list : module 'tutor/template/forms/drop_down_list'
      saved_filters : module 'tutor/template/forms/drop_down_list'
      place : module 'tutor/template/choice' :
        id          : 'place'
        indent      : '10px'
        choice_list : [
          module 'tutor/template/button' :
            text  : 'У себя'
            selector  : 'streamlined'

          module 'tutor/template/button' :
            text  : 'У ученика'
            selector  : 'fixed'

          module 'tutor/template/button' :
            text  : 'Удалённо'
            selector  : 'dark_blue'
        ]
      address_list : module 'tutor/template/forms/drop_down_list'
      save_button : module 'tutor/template/button' :
        text  : 'Сохранить'
        selector  : 'fixed'

      road_time : module 'tutor/template/forms/input' :
        width : '50px'

      separate_line : module 'tutor/template/separate_line' :
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
            report_block : false
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
            report_block : false
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
        ]
      courses_list : module 'tutor/template/forms/drop_down_list'
  init : ->
    @parent.tree.left_menu.setActive 'Заявки'





