class @main
  tree : => module '$' :
      title               : @exports()
      at_home_button      : @exports()
      in_tutoring_button  : @exports()
      remotely_button     : @exports()
      address_input       : @exports()
      list_subject        : @exports()
      price_slider_top    : @exports()
      button_back         : module 'tutor/button'  :
        selector  : 'subject_back'
        text      : 'Назад'
      button_issue        : module 'tutor/button'  :
        selector  : 'issue_bid'
        text      : 'Оформить заявку сейчас'
      button_onward        : module 'tutor/button'  :
        selector  : 'onward_block'
        text      : 'Далее'
