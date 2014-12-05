
class @main extends template 'tutor/template/template'
  route : '/tutor/reviews'
  tree : ->
    content : module 'tutor/profile/reviews':
      tutor_rating :36
      pupils_number : 6
      ###
      tutor_rating - рейтинг тутора в процентах. Например 85.
      ###
      line : module 'tutor/template/separate_line':
        type : 'vertical'
      list_reviews : [
        module 'tutor/profile/reviews/review' :
          photo_src : '#'
          mini_rating : '25'
          ###
          mini_rating - в процентах
          ###
          user_name : 'Аркадий Аркадиевич'
          review_text : 'В Диске Google предоставляется 15 Гб для бесплатного хранения данных. Если выделенного объёма недостаточно, можно приобрести дополнительно от 100 ГБ до 30 ТБ.[2]13 мая 2013 года Google объявила об объединении лимитов на дисковое пространство Gmail, Google Диск и Google+ Photos. Вместо старых лимитов 10 ГБ на Gmail и 5 ГБ на Google Диск и Google+ Photos теперь пользователь получает 15 ГБ на всё сразу, в том числе и на Google Диск.[4]
    '
          creation_date : '20 ноября 2014'

        module 'tutor/profile/reviews/review' :
          photo_src : '#'
          mini_rating : '40'
          user_name : 'Витя'
          review_text : 'В Диске Google предоставляется 15 Гб для бесплатного хранения данных. Если выделенного объёма недостаточно, можно приобрести дополнительно от 100 ГБ до 30 ТБ.[2]13 мая 2013 года Google объявила об объединении лимитов на дисковое пространство Gmail, Google Диск и Google+ Photos. Вместо старых лимитов 10 ГБ на Gmail и 5 ГБ на Google Диск и Google+ Photos теперь пользователь получает 15 ГБ на всё сразу, в том числе и на Google Диск.[4]
    '
          creation_date : '10 декабря 2014'
      ]

  init : ->
    @parent.tree.left_menu.setActive 'Анкета'
    @parent.tree.header.top_menu.active_item = 'Отзывы'