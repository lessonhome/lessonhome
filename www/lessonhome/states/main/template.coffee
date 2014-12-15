class @main
  tree : -> module 'main/template' :
    header        : state '../tutor/template/header'
    content       : @exports()   # must be defined
  init_ : =>
    #console.log @tree.header
    #@tree.header.top_menu.items =
      #'Стать учеником'  : 'be_pupil'
      #'Репетиторам'     : 'tutors'
      #'О нас'           : 'about us'