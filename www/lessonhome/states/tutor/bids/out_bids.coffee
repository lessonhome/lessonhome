class @main extends template '../../tutor'
  route : '/tutor/out_bids'
  model   : 'tutor/bids/out_bids'
  title : "исходящие заявки"
  tags   : -> 'tutor:out_bids'
  access : ['tutor']
  redirect : {
    'default' : 'main/first_step'
  }
  tree : ->
    items : [
      module 'tutor/header/button' : {
        title : 'Поиск'
        href  : '/tutor/search_bids'
      }
      module 'tutor/header/button' : {
        title : 'Входящие'
        href  : '/tutor/in_bids'
      }
      module 'tutor/header/button' : {
        title : 'Исходящие'
        href  : '/tutor/out_bids'
        tag   : 'tutor:out_bids'
      }
      module 'tutor/header/button' : {
        title : 'Отчёты'
        href  : '/tutor/reports'
      }
    ]
    content : module '$' :
      hint : module 'tutor/hint_dz' :
        selector  : ''
        text      : 'Дополнительную информацию по заявке можно открыть по клику.'
      select_all_checkbox : module 'tutor/forms/checkbox' :
        selector : 'small'
      sort_list     : module 'tutor/forms/drop_down_list':
        placeholder : 'Все'
        selector    : 'in_bids'
      subject : module 'tutor/forms/drop_down_list':
        placeholder : 'Предмет'
        selector    : 'in_bids'

      list_bids : module 'tutor/bids/list_bids' :
        titles_bid : module '//titles_bid' :
          indent     : true

          number_date   : 'Номер/Дата'
          subject_level : 'Предмет/Уровень'
          place         :'Место'
          city_district : 'Город/Район'
          bet           : 'Ставка'
          price         : 'Цена'
          status        : 'Статус'

        all_bids : [
          module '//bid' :
            selectable   : true
            checkbox  : module 'tutor/forms/checkbox' :
              selector : 'small'

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
            status    : 'Ожидание'

            category_pupil      : 'школьники 6-8 классов'
            training_direction  : 'ЕГЭ'
            number_of_lessons   :  'Более 20'
            wishes              : 'Утро выходных дней'
            near_metro          : 'м.Крюково'
            comments            : '-'
            lesson_goal         : 'Устранить пробелы в знаниях'

          module '//bid' :
            selectable   : true
            checkbox  : module 'tutor/forms/checkbox' :
              selector : 'small'

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
            status    : 'Ожидание'

            category_pupil      : 'школьники 6-8 классов'
            training_direction  : 'ЕГЭ'
            number_of_lessons   :  'Более 20'
            wishes              : 'Утро выходных дней'
            near_metro          : 'м.Крюково'
            comments            : '-'
            lesson_goal         : 'Устранить пробелы в знаниях'
        ]
  init : ->
    @parent.tree.left_menu.setActive 'Заявки'