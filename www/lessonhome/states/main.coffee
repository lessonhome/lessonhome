class @main
  tree : -> module '$' :
    header     : state './tutor/template/header'
    top_filter : module '$/top_filter' :
      content   : @exports 'top_filter'
    info_panel : module '$/info_panel'
    content    : @exports()   # must be defined

  init_ : ->

    #console.log @tree.header
    #@tree.header.top_menu.items =
    #'Стать учеником'  : 'be_pupil'
    #'Репетиторам'     : 'tutors'
    #'О нас'           : 'about us'
