@route = '/tutor/bids'

@struct = state 'tutor/template/template'

@struct.content = module './pages/search' :
  search_block : module '//search_block'
  list_bids : module '//list_bids' :
    title_names : [
      'Номер/Дата'
      'Предмет/Уровень'
      'Место'
      'Город/Район'
      'Ставка'
      'Цена'
      'Статус'
    ]
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
    ]


@struct.left_menu.active_item = 'Заявки'
@struct.edit_line.top_menu.items = {'Поиск' : '#', 'Заказы' : '#', 'Заявки' : '#', 'Отчёт' : '#'}
@struct.edit_line.top_menu.active_item = 'Поиск'

