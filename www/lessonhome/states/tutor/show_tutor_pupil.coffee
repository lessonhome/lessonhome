class @main
  tree  : => @module '$':
    content : @exports()
    items : [
      @module 'tutor/header/button' :
        href  : '/second_step_popup_profile'
        title : "Анкета"
        tag   : @exports 'menu_profile'
      @module 'tutor/header/button' :
        href  : '/second_step_popup_conditions'
        title : "Условия"
        tag   : @exports 'menu_conditions'
      @module 'tutor/header/button' :
        href  : '/second_step_popup_reviews'
        title : "Отзывы"
        tag   : @exports 'menu_reviews'
    ]
    send_bid_this_tutor : @state './send_bid_this_tutor' :
      have_small_button : @exports()
    line_top      : @module 'tutor/separate_line':
      selector  : 'horizon'
