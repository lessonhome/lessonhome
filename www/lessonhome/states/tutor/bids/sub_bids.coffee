@route = '/tutor/bids/sub_bids'

@struct = state 'tutor/template/template'

@struct.content = module 'tutor/bids/pages/sub_bids' :
  hint : module 'tutor/template/hint' :
    type : 'horizontal'
    header : 'Это подсказка'
    text : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит. Однако в некоторых исключительных случаях зависимость какой-либо величины от времени может оказаться пренебрежимо слабой, так что с высокой точностью можно считать эту характеристику независящей от времени. Если такие величины описывают динамику какой-либо системы,'


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






  ]

@struct.left_menu.items = { 'Анкета': '../profile', 'Заявки': '../bids', 'Оплата': '#', 'Документы': '#', 'Форум': '#', 'Статьи': '#', 'Поддержка': '#' }
@struct.left_menu.active_item = 'Заявки'
@struct.edit_line.top_menu.items = {'Поиск' : '../bids', 'Заказы' : 'orders', 'Заявки' : 'sub_bids', 'Отчёт' : 'report'}
@struct.edit_line.top_menu.active_item = 'Заявки'