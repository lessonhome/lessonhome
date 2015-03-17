class @main
  tree  : => module '$':
    content : @exports()
    items : [
      module 'tutor/header/button' :
        href  : '/second_step_popup_profile'
        title : "Анкета"
      module 'tutor/header/button' :
        href  : '/second_step_popup_conditions'
        title : "Условия"
      module 'tutor/header/button' :
        href  : '/second_step_popup_reviews'
        title : "Отзывы"
        tag   : 'popup_reviews_tutor'
    ]
    send_bid_this_tutor : state './send_bid_this_tutor' :
      have_small_button : @exports()
    line_top      : module 'tutor/separate_line':
      selector  : 'horizon'
