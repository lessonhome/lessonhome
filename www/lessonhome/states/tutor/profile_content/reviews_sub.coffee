class @main
  tree : ->
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
    content : state './reviews_content' :
      send_bid_this_tutor : state './send_bid_this_tutor' :
        have_small_button : true