class @main extends template '../../tutor'
  route : '/tutor/reports'
  model   : 'tutor/bids/reports'
  title : "отчет"
  tags   : -> 'tutor:reports'
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
      }
      module 'tutor/header/button' : {
        title : 'Отчёты'
        href  : '/tutor/reports'
        tag   : 'tutor:reports'
      }
    ]
    content : module '$' :
      popup : @exports()
      hint : module 'tutor/hint' :
        selector  : 'horizontal_hide_ability'
        header    : ''
        text      : 'Нажмите на заявку, чтобы раскрыть всю информацию.<br>Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени,
               как обычно и происходит. Однако в некоторых исключительных случаях зависимость какой-либо величины от времени может оказаться пренебрежимо слабой'

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
          module '//report_bid' :
            selectable     : true
            checkbox       : module 'tutor/forms/checkbox' :
              selector : 'small'
            fill_button    : module 'tutor/button' :
              selector: 'fill'
              text: 'Заполнить'
            support_button : module 'link_button' :
              selector: 'support'
              text: 'Поддержка'
              href: 'reports/support'

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
            status    : 'start'

            category_pupil      : 'школьники 6-8 классов'
            training_direction  : 'ЕГЭ'
            number_of_lessons   :  'Более 20'
            wishes              : 'Утро выходных дней'
            near_metro          : 'м.Крюково'
            comments            : '-'
            lesson_goal         : 'Устранить пробелы в знаниях'

            full_name           : 'Дудко Артемий Львович'
            phone               : '+7(499)4653638'
            post                : 'seragj@mail.ru'
            skype               : 'melanholic'
            wish_time           : 'вторник 18:30-20:00'

            first_call          :
              selector: 'filled'
              default_text: 'Как прошло первое занятие?'
              value: 'отлично'
              fill_button_href: 'first_call'
            first_lesson_date   :
              selector: 'active'
              default_text: 'Дата первого занятия'
              value: false
              fill_button_href: 'first_lesson_date'
            first_lesson_result :
              selector: 'inactive'
              default_text: 'Ознакомительный звонок ученику'
              value: false
              fill_button_href: 'first_lesson_result'
            payment             :
              selector: 'inactive'
              default_text: 'Оплата'
              value: false
              fill_button_href: 'payment'


          module '//report_bid' :
            selectable   : true
            checkbox  : module 'tutor/forms/checkbox' :
              selector : 'small'
            fill_button    : module 'tutor/button' :
              selector: 'fill'
              text: 'Заполнить'
            support_button : module 'link_button' :
              selector: 'support'
              text: 'Поддержка'
              href: 'reports/support'

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
            status    : 'start'

            category_pupil      : 'школьники 6-8 классов'
            training_direction  : 'ЕГЭ'
            number_of_lessons   :  'Более 20'
            wishes              : 'Утро выходных дней'
            near_metro          : 'м.Крюково'
            comments            : '-'
            lesson_goal         : 'Устранить пробелы в знаниях'

            full_name           : 'Дудко Артемий Львович'
            phone               : '+7(499)4653638'
            post                : 'seragj@mail.ru'
            skype               : 'melanholic'
            wish_time           : 'вторник 18:30-20:00'

            first_call          :
              selector: 'filled'
              default_text: 'Как прошло первое занятие?'
              value: 'Первый звонок прошёл удачно'
              fill_button_href: 'first_call'
            first_lesson_date   :
              selector: 'filled'
              default_text: 'Дата первого занятия'
              value: '13 января'
              fill_button_href: 'first_lesson_date'
            first_lesson_result :
              selector: 'active'
              default_text: 'Ознакомительный звонок ученику'
              value: false
              fill_button_href: 'first_lesson_result'
            payment             :
              selector: 'inactive'
              default_text: 'Оплата'
              value: false
              fill_button_href: 'payment'
        ]
  init : ->
    @parent.tree.left_menu.setActive 'Заявки'