

# filling       : @exports()
#selector      : 'padding_1px_rating'
class @main
  tree : => @module '$' :
    selector  : @exports()
    rating_photo  : @state './all_rating_photo' :
      image         : @exports()
      count_review  : @exports()
      cost          : @exports()
      close         : false
      extract       : @exports()
      rating        : @exports()
      showrating    : @exports()
      showsubject   : @exports()
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
      view_button       : @module 'link_button' :
        selector: 'view'
        text: 'Смотреть'
      choose_button     : @module 'tutor/checkbox_button' :
        checkbox        : @module 'tutor/forms/checkbox' :
          value : false
          selector: 'small'
        selector  : 'choose'
        text      : 'выбрать'
      add_button_bid    : @module 'tutor/button' :
        selector  : 'add_button_bid'
        text      : 'Прикрепить к заявке'
      stars       : @exports() # it's mean have rating start in visit card
      reclame     : @exports() # It's mean visit card in jump page
      all_rating    : @module 'rating_star'  :
        selector  : @exports()
        value :
          rating    : @exports()
        filling   : @exports()


