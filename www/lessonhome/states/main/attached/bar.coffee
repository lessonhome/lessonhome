class @main
  tree: => @module '$' :
    linked_tutors : @module 'main/attached/bar/linked_tutors' :
      tutor : @module 'main/attached/bar/linked_tutors/tutor_smallest'
      button_attach : @module 'link_button' :
        text : 'Оформить заявку'
        selector : 'view'

