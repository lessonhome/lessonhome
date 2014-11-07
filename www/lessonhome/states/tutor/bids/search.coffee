@route = '/tutor/bids'

@struct = state 'tutor/template/template'

@struct.content = module './pages/search' :
  search_block : module '//search_block'
  list_bids : module '//list_bids' :

    titles : module './title_bids' :
      number_date   : 'Номер/Дата'
      subject_level : 'Предмет/Уровень'
      place         :'Место'
      city_district : 'Город/Район'
      bet           : 'Ставка'
      price         : 'Цена'
      status        : 'Статус'
      payment       : 'Оплата'

    all_bids : [
      module './bid' :
        number    : 25723
        date      : "10 ноября"
        subject   : 'Физика'
        level     : '6 класс'
        place     : 'У ученика'
        city      : 'Москва'
        district  : 'Бирюлёво'
        bet       : '1000 рублей/90 мин'
        price     : '1500 руб.'
        status    : 'Принять/Отклонить'
        payment   : '#'

      module './bid' :
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
    ]


@struct.left_menu.active_item           = 'Заявки'
@struct.edit_line.top_menu.items        =
  'Поиск'   : '#'
  'Заказы'  : 'orders'
  'Заявки'  : 'bids'
  'Отчёт'   : 'bids/report'
@struct.edit_line.top_menu.active_item  = 'Поиск'

