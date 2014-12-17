class @main
  tree : -> module 'main_tutor_template' :
    header     : state './tutor/template/header'
    content    : @exports()   # must be defined

  init : ->
    @tree.header.top_menu.items =
      'Стать учеником'  : 'be_pupil'
      'Репетиторам'     : 'main_tutor'
      'О нас'           : 'about us'
