class @main
  tree : ->
    items : [
      module 'tutor/header/button' : {
        href  : '/second_step_popup_profile'
        title : "Анкета"
      }
      module 'tutor/header/button' : {
        href  : '/second_step_popup_conditions'
        title : "Условия"
      }
      module 'tutor/header/button' : {
        href  : '/second_step_popup_reviews'
        title : "Отзывы"
      }
    ]
    content : state './conditions_content'