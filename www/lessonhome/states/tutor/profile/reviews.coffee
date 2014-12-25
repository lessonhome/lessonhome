class @main extends template '../../tutor'
  route : '/tutor/profile/reviews'
  model : 'tutor/profile/reviews'
  title : "отзывы"
  tree : ->
    items : [
      module 'tutor/header/button' : {
        title : 'Описание'
        href  : '/tutor/profile'
      }
      module 'tutor/header/button' : {
        title : 'Условия'
        href  : '/tutor/conditions'
      }
      module 'tutor/header/button' : {
        title : 'Отзывы'
        href  : '/tutor/reviews'
      }
    ]
    content : module '$':
      tutor_rating :36
      pupils_number : 6
      ###
      tutor_rating - рейтинг тутора в процентах. Например 85.
      ###
      line : module 'tutor/separate_line':
        selector : 'vertical'
      list_reviews : [
        module '$/review' :
          photo_src : '#'
          mini_rating : '25'
          ###
          mini_rating - в процентах
          ###
          user_name : 'Аркадий Аркадиевич'
          review_text : 'В Диске Google предоставляется 15 Гб для бесплатного хранения данных. Если выделенного объёма недостаточно, можно приобрести дополнительно от 100 ГБ до 30 ТБ.[2]13 мая 2013 года Google объявила об объединении лимитов на дисковое пространство Gmail, Google Диск и Google+ Photos. Вместо старых лимитов 10 ГБ на Gmail и 5 ГБ на Google Диск и Google+ Photos теперь пользователь получает 15 ГБ на всё сразу, в том числе и на Google Диск.[4]
    '
          creation_date : '20 ноября 2014'

        module '$/review' :
          photo_src : '#'
          mini_rating : '40'
          user_name : 'Витя'
          review_text : 'В Диске Google предоставляется 15 Гб для бесплатного хранения данных. Если выделенного объёма недостаточно, можно приобрести дополнительно от 100 ГБ до 30 ТБ.[2]13 мая 2013 года Google объявила об объединении лимитов на дисковое пространство Gmail, Google Диск и Google+ Photos. Вместо старых лимитов 10 ГБ на Gmail и 5 ГБ на Google Диск и Google+ Photos теперь пользователь получает 15 ГБ на всё сразу, в том числе и на Google Диск.[4]
    '
          creation_date : '10 декабря 2014'
      ]

  init : ->
    @parent.tree.left_menu.setActive 'Анкета'
