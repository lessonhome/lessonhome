
class @main extends @template '../main'
  tree : =>
    content : @module '$' :
      selector: @exports()
      general:  @module 'link_button' :
        text: 'ОБЩЕЕ'
        selector: @exports 'g_selector'
        href: '/profile/general'
        active: true
      subjects : @module 'link_button' :
        text: 'ПРЕДМЕТЫ/РАСПОЛОЖЕНИЕ'
        selector: @exports 's_selector'
        href: '/profile/subjects'
        active: true
      reviews: @module 'link_button' :
        text: 'ОТЗЫВЫ'
        selector: @exports 'r_selector'
        href: '/profile/reviews'
        active: true
      content : @exports()
      contact_tutor_button: @module 'tutor/button' :
        text: 'Связаться с репетитором'
        selector: 'profile_contact'
      add_to_bid_button: @module 'tutor/button' :
        text: 'Прикрепить к заявке'
        selector: 'profile_add'

