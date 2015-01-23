class @main
  tree : => module '$' :
    rating_photo  : state './all_rating_photo' :
      src           : @exports()
      filling       : @exports()
      count_review  : @exports()
      selector      : 'padding_1px_rating'
      close         : false
      extract       : 'extract'
    tutor_extract : module '$/tutor_extract'  :
      tutor_name        : @exports()
      with_verification : @exports()
      tutor_subject     : @exports()
      tutor_status      : @exports()
      tutor_exp         : @exports()
      tutor_place       : @exports()
      tutor_title       : @exports()
      tutor_text        : @exports()
      tutor_price       : @exports()
      add_button_bid    : module 'tutor/button' :
        selector  : 'add_button_bid'
        text      : 'Прикрепить к заявке'



