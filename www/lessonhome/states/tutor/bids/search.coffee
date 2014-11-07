@route = '/tutor/bids'

@struct = state 'tutor/template/template'

@struct.content = module 'tutor/bids/pages/search' :
  search_block : module 'tutor/bids/pages/search/search_block'
  list_bids : module 'tutor/bids/pages/search/list_bids' :

    titles : module 'tutor/bids/title_bids' :
      number_date   : 'Номер/Дата'
      subject_level : 'Предмет/Уровень'
      place         :'Место'
      city_district : 'Город/Район'
      bet           : 'Ставка'
      price         : 'Цена'
      status        : 'Статус'
      payment       : 'Оплата'

    all_bids : [
      module 'tutor/bids/bid' :
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

        category_pupil : 'школьники 6-8 классов'
        training_direction : 'ЕГЭ'
        number_of_lessons :  'Более 20'
        wishes : 'Утро выходных дней'
        near_metro : 'м.Крюково'
        comments : '-'
        lesson_goal : 'Устранить пробелы в знаниях'

      module 'tutor/bids/bid' :
        number    : 15723
        date      : "20 декабря"
        subject   : 'Математика'
        level     : '8 класс'
        place     : 'У ученика'
        city      : 'Москва'
        district  : 'Выхино'
        bet       : '1000 рублей/90 мин'
        price     : '1500 руб.'
        status    : 'Принять/Отклонить'
        payment   : '#'

        category_pupil : 'школьники 6-8 классов'
        training_direction : 'ЕГЭ'
        number_of_lessons :  'Более 20'
        wishes : 'Утро выходных дней'
        near_metro : 'м.Крюково'
        comments : '-'
        lesson_goal : 'Устранить пробелы в знаниях'
    ]


@struct.left_menu.active_item = 'Заявки'
@struct.edit_line.top_menu.items = {'Поиск' : '#', 'Заказы' : 'orders', 'Заявки' : 'bids/sub_bids', 'Отчёт' : 'bids/report'}
@struct.edit_line.top_menu.active_item = 'Поиск'


 