@route = '/tutor/search_bids'

@struct = state 'tutor/template/template'

@struct.left_menu.setActive.call(@struct.left_menu,'Заявки')


@struct.content = module 'tutor/bids/search_bids' :

  subject_list : module 'tutor/template/forms/drop_down_list' :
    width : @struct.vars.input_width1

  saved_filters : module 'tutor/template/forms/drop_down_list' :
    width : @struct.vars.input_width1

  place : module 'tutor/template/choice' :
    id : 'place'
    indent : '10px'
    choice_list : [
      module 'tutor/template/button' :
        text  : 'У себя'
        type  : 'streamlined'

      module 'tutor/template/button' :
        text  : 'У ученика'
        type  : 'fixed'

      module 'tutor/template/button' :
        text  : 'Удалённо'
        type  : 'fixed'
    ]

  address_list : module 'tutor/template/forms/drop_down_list' :
    width : @struct.vars.input_width1

  save_button : module 'tutor/template/button' :
    text  : 'Сохранить'
    type  : 'fixed'

  road_time : module 'tutor/template/forms/input' :
    width : '50px'

  list_bids : module 'tutor/bids/list_bids' :
    titles_bid : module '//titles_bid' :
      number_date   : 'Номер/Дата'
      subject_level : 'Предмет/Уровень'
      place         :'Место'
      city_district : 'Город/Район'
      bet           : 'Ставка'
      price         : 'Цена'

    all_bids : [
      module '//bid' :
        number   : 25723
        date     : "10 ноября"
        subject  : 'Физика'
        level    : '6 класс'
        place    : 'У ученика'
        city     : 'Москва'
        district : 'Бирюлёво'
        bet      : '1000 рублей/90 мин'
        price    : '1500 руб.'

        category_pupil : 'школьники 6-8 классов'
        training_direction : 'ЕГЭ'
        number_of_lessons :  'Более 20'
        wishes : 'Утро выходных дней'
        near_metro : 'м.Крюково'
        comments : '-'
        lesson_goal : 'Устранить пробелы в знаниях'

      module '//bid' :
        number    : 15723
        date      : "20 декабря"
        subject   : 'Математика'
        level     : '8 класс'
        place     : 'У ученика'
        city      : 'Москва'
        district  : 'Выхино'
        bet       : '1000 рублей/90 мин'
        price     : '1500 руб.'

        category_pupil : 'школьники 6-8 классов'
        training_direction : 'ЕГЭ'
        number_of_lessons :  'Более 20'
        wishes : 'Утро выходных дней'
        near_metro : 'м.Крюково'
        comments : '-'
        lesson_goal : 'Устранить пробелы в знаниях'
    ]


@struct.left_menu.active_item = 'Заявки'
@struct.header.top_menu.items = {'Поиск' : 'search_bids', 'Заказы' : 'in_bids', 'Заявки' : 'out_bids', 'Отчёты' : 'report'}
@struct.header.top_menu.active_item = 'Поиск'


 