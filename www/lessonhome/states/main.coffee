class @main
  tree : -> module '$' :
    depend :  state 'lib'
    header     : state './tutor/template/header'
    top_filter : module '$/top_filter' :
      content   : @exports 'top_filter'
    info_panel : module '$/info_panel'
    content    : @exports()   # must be defined

  init : ->
    p = @tree.info_panel
    p.math              = 'Математические +'
    p.natural_research  = 'Естественно-научные +'
    p.philology         = 'Филологичные +'
    p.foreign_languages = 'Иностранные языки +'
    p.others            = 'Другие +'

    @tree.header.top_menu.items =
      'Стать учеником'  : 'be_pupil'
      'Репетиторам'     : 'main_tutor'
      'О нас'           : 'about us'
