
class @main extends template 'tutor/template/template'
  route : '/tutor/reports'
  model   : 'tutor/reports'
  tree : ->
    content : module 'tutor/bids/reports' :
      hint : module 'tutor/template/hint' :
        selector  : 'horizontal_hide_ability'
        header    : ''
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
            selectable     : true
            report_block   : true
            checkbox       : module 'tutor/template/forms/checkbox' :
              selector : 'bid'
            fill_button    : module 'tutor/template/button' :
              text  : 'Заполнить'
              selector  : 'fill'
            support_button : module 'tutor/template/button' :
              text  : 'Поддержка'
              selector  : 'support'

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


          module '//bid' :
            selectable   : true
            report_block : true
            checkbox  : module 'tutor/template/forms/checkbox' :
              selector : 'bid'
            fill_button    : module 'tutor/template/button' :
              text  : 'Заполнить'
              selector  : 'fill'
            support_button : module 'tutor/template/button' :
              text  : 'Поддержка'
              selector  : 'support'

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
        ]


  init : ->
    @parent.setTopMenu 'Отчёты', {
      'Поиск'     : 'search_bids'
      'Входящие'  : 'in_bids'
      'Исходящие' : 'out_bids'
      'Отчёты'    : 'reports'

    }

    @parent.tree.left_menu.setActive 'Заявки'








###
  @route = '/tutor/report'

  @struct = state 'tutor/template/template'


  @left_menu_href = ['../profile', '../bids', '#', '#', '#', '#', '#']
  for href,i in @left_menu_href
    @struct.left_menu.items[i].href = href

  @struct.left_menu.setActive.call(@struct.left_menu,'Заявки')



  @struct.content = module 'tutor/bids/report' :
    hint : module 'tutor/template/hint' :
      selector : 'horizontal'
      header : 'Это подсказка'
      text : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит. Однако в некоторых исключительных случаях зависимость какой-либо величины от времени может оказаться пренебрежимо слабой, так что с высокой точностью можно считать эту характеристику независящей от времени. Если такие величины описывают динамику какой-либо системы,'

    illustrations : [
      module 'mime/photo' :
        src : '#'

      module 'mime/photo' :
        src : '#'

      module 'mime/photo' :
        src : '#'

      module 'mime/photo' :
        src : '#'

      module 'mime/photo' :
        src : '#'

    ]

    titles : module 'tutor/bids/list_bids/titles_bid' :
      number_date   : 'Номер/Дата'
      subject_level : 'Предмет/Уровень'
      place         :'Место'
      city_district : 'Город/Район'
      bet           : 'Ставка'
      price         : 'Цена'
      status        : 'Статус'
      payment       : 'Оплата'

    working_bids : [
      module 'tutor/bids/report/report_bid' :
        number   : 25723
        date     : "10 ноября"
        subject  : 'Физика'
        level    : '6 класс'
        place    : 'У ученика'
        city     : 'Москва'
        district : 'Бирюлёво'
        bet      : '1000 рублей/90 мин'
        price    : '1500 руб.'
        status   : 'Принять/Отклонить'
        payment  : '#'

        report_block : module 'tutor/bids/report/report_bid/report_block' :
          additional_info : undefined
          name   : 'Дудко Артемий Львович'
          data : [
            'Телефон:'    : '+7 (499) 564 44 66'
            'Почта:'      : 'blabla@gmail.com'
            'Skype:'      : 'gerakl'
            'День/время:' : 'вторник 18:30 - 20:00'
          ]

          payment : [
            'Цена заказа:'  : '1100 р.'
            'Статус:'       : ''
          ]

          review : 'Vi ser till att kostymen alltid sitter perfekt på dig, hur du än ser ut. Nu letar vi efter de tre personer som kommer passa perfekt i våra specialanpassade och unika kostymer. Du tävlar genom att vi tar dina mått.'
          report : 'Vi ser till att kostymen alltid sitter perfekt på dig, hur du än ser ut. Nu letar vi efter de tre personer som kommer passa perfekt i våra specialanpassade och unika kostymer. Du tävlar genom att vi tar dina mått.'

    ]


  @struct.header.top_menu.items = {'Поиск' : 'search_bids', 'Входящие' : 'in_bids', 'Исходящие' : 'out_bids', 'Отчёт' : 'report'}
  @struct.header.top_menu.active_item = 'Отчёт'



###