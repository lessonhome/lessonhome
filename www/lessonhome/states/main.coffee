class @main
  tree : -> module '$' :
    depend :  state 'lib'
    header     : state './tutor/header' :
      items : [
        module 'tutor/header/button' : {
          title : 'Поиск'
          href  : '/search'
        }
        module 'tutor/header/list_button' : {
          title : 'Стать учеником'
          href  : '/be-pupil'
          list  : {
            'Тест' : '#'
            'Тест1' : '#'
            'Тест2' : '#'
          }
        }
        module 'tutor/header/list_button' : {
          title : 'Репетиторам'
          href  : '/for-tutors'
          list  : {
            'как это работает1' : '#'
            'как это работает2' : '#'
            'как это работает3' : '#'
          }
        }
        module 'tutor/header/button' : {
          title : 'О нас'
          href  : '/about us'
        }
      ]
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
