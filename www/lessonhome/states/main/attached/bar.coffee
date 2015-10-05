class @main
  tree: => @module '$' :
    plugins : 'lib/plugins/jCarousel.js'
    tutor : @module 'main/attached/bar/tutor_smallest'
    button_attach : @module 'link_button' :
      text : 'Оформить заявку'
      selector : 'view'

