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
      bet      : '1000 руб./90 мин'
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