class @main
  tree : => @module '$' :
    title               : @exports()
    at_home_button      : @exports()
    in_tutoring_button  : @exports()
    remotely_button     : @exports()
    address_input       : @exports()
    list_subject        : @exports()
    tutor_status        : @exports()
    choose_subject      : @exports()
    empty_choose_subject: @exports()
    price_slider_top    : @exports()
    button_back         : @module 'link_button'  :
      selector  : 'subject_back'
      text      : 'Назад'
      href      : @exports 'link_back'
    button_issue        : @module 'link_button'  :
      selector  : 'issue_bid'
      text      : 'Оформить заявку сейчас'
      href      : '/fast_bid/first_step'
    button_onward        : @module 'link_button'  :
      selector  : 'onward_block'
      text      : 'Далее'
      href      : @exports 'link_forward'
