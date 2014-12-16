class @main
  tree : -> module 'main/template' :
    header        : state '../tutor/template/header'
    search_block  : module 'main/template/search_background' :
      filter : @exports()
    info_panel     : module 'main/info_panel'
    content       : @exports()   # must be defined

  init_ : ->

    #console.log @tree.header
    #@tree.header.top_menu.items =
      #'Стать учеником'  : 'be_pupil'
      #'Репетиторам'     : 'tutors'
      #'О нас'           : 'about us'
