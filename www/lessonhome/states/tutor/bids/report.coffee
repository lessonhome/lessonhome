@route = '/tutor/bids/report'

@struct = state 'tutor/template/template'

@struct.content = module 'tutor/bids/pages/report' :
  hint : module 'tutor/template/hint' :
    type : 'horizontal'
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

  titles : module 'tutor/bids/title_bids' :
    number_date   : 'Номер/Дата'
    subject_level : 'Предмет/Уровень'
    place         :'Место'
    city_district : 'Город/Район'
    bet           : 'Ставка'
    price         : 'Цена'
    status        : 'Статус'
    payment       : 'Оплата'

  working_bids : [
    module 'tutor/bids/pages/report/report_bid' :
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

      report_block : module 'tutor/bids/pages/report/report_bid/report_block' :
        additional_info : undefined
        name   : 'Дудко Артемий Львович'
        data : [
          'Телефон:' : '+7 (499) 564 44 66'
          'Почта:'   : 'blabla@gmail.com'
          'Skype:'  : 'gerakl'
          'День/время:' : 'вторник 18:30 - 20:00'
        ]

        payment : [
          'Цена заказа:' : '1100 р.'
          'Статус:' : ''
        ]

        review : 'Vi ser till att kostymen alltid sitter perfekt på dig, hur du än ser ut. Nu letar vi efter de tre personer som kommer passa perfekt i våra specialanpassade och unika kostymer. Du tävlar genom att vi tar dina mått.'
        report : 'Vi ser till att kostymen alltid sitter perfekt på dig, hur du än ser ut. Nu letar vi efter de tre personer som kommer passa perfekt i våra specialanpassade och unika kostymer. Du tävlar genom att vi tar dina mått.'

  ]

@struct.left_menu.items = { 'Анкета': '../profile', 'Заявки': '../bids', 'Оплата': '#', 'Документы': '#', 'Форум': '#', 'Статьи': '#', 'Поддержка': '#' }
@struct.left_menu.active_item = 'Заявки'
@struct.header.top_menu.items = {'Поиск' : '../bids', 'Заказы' : 'orders', 'Заявки' : 'sub_bids', 'Отчёт' : 'report'}
@struct.header.top_menu.active_item = 'Отчёт'