

# filling       : @exports()
#selector      : 'padding_1px_rating'
class @main
  tree : => @module '$' :
    rating_photo  : @state './all_rating_photo' :
      image         : @exports()
      count_review  : @exports()
      close         : false
      extract       : 'extract'
      rating        : @exports()
    tutor_extract : @module '$/tutor_extract'  :
      value : @exports()
      ### value have variables
        tutor_name        - имя репетитора
        with_verification - верификация
        tutor_subject     - предмет преподования
        tutor_status      - статус
        tutor_exp         - опыт
        tutor_place       - место преподования
        tutor_title       - заголовок
        tutor_text        - текст
        tutor_price       - стоимость
      ###
      add_button_bid    : @module 'tutor/button' :
        selector  : 'add_button_bid'
        text      : 'Прикрепить к заявке'



