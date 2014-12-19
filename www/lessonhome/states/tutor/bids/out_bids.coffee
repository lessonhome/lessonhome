
class @main extends template 'tutor/template/template'
  route : '/tutor/out_bids'
  model   : 'tutor/out_bids'
  title : "исходящие заявки"
  tree : ->
    content : module 'tutor/bids/out_bids' :
      hint : module 'tutor/template/hint' :
        selector  : 'horizontal'
        header    : 'Это подсказка'
        text      : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени,
               как обычно и происходит. Однако в некоторых исключительных случаях зависимость какой-либо величины от времени может оказаться пренебрежимо слабой,
                так что с высокой точностью можно считать эту характеристику независящей от времени. Если такие величины описывают динамику какой-либо системы,'

      select_all_checkbox : module 'tutor/template/forms/checkbox'
      select_all_list     : module 'tutor/template/forms/drop_down_list'
      subject : module 'tutor/template/forms/drop_down_list'

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
            report_block : false
            checkbox  : module 'tutor/template/forms/checkbox' :
              selector : 'bid'

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
            report_block : false
            checkbox  : module 'tutor/template/forms/checkbox' :
              selector : 'bid'

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
    @parent.setTopMenu 'Исходящие', {
      'Поиск'     : 'search_bids'
      'Входящие'  : 'in_bids'
      'Исходящие' : 'out_bids'
      'Отчёты'    : 'reports'

    }

    @parent.tree.left_menu.setActive 'Заявки'