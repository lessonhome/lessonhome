class @main
  tree  : => module '$':
    reviews_rating  : module 'rating_star':
      filling   : 50
      selector      : 'padding_no'
    pupils_number : 6
#    line : module 'tutor/separate_line':
#      selector : 'vertical'
    list_reviews : [
      state './review' :
        photo_src : '#'
        filling   : 100
        user_name : 'Аркадий Аркадиевич'
        review_text : 'В Диске Google предоставляется 15 Гб для бесплатного хранения данных. Если выделенного объёма недостаточно, можно приобрести дополнительно от 100 ГБ до 30 ТБ.[2]13 мая 2013 года Google объявила об объединении лимитов на дисковое пространство Gmail, Google Диск и Google+ Photos. Вместо старых лимитов 10 ГБ на Gmail и 5 ГБ на Google Диск и Google+ Photos теперь пользователь получает 15 ГБ на всё сразу, в том числе и на Google Диск.[4]'
        creation_date : '20 ноября 2014'

      state './review' :
        photo_src : '#'
        filling : 50
        user_name : 'Витя'
        review_text : 'В Диске Google предоставляется 15 Гб для бесплатного хранения данных. Если выделенного объёма недостаточно, можно приобрести дополнительно от 100 ГБ до 30 ТБ.[2]13 мая 2013 года Google объявила об объединении лимитов на дисковое пространство Gmail, Google Диск и Google+ Photos. Вместо старых лимитов 10 ГБ на Gmail и 5 ГБ на Google Диск и Google+ Photos теперь пользователь получает 15 ГБ на всё сразу, в том числе и на Google Диск.[4]'
        creation_date : '10 декабря 2014'
    ]