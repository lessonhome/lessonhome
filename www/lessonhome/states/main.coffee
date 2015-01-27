class @main
  tree : -> module '$' :
    depend      :  state 'lib'
    header      : state './tutor/header' :
      items : [
        module 'tutor/header/button' : {
          title : 'Поиск'
          href  : '/first_step'
        }
        module 'tutor/header/list_button' : {
          title : 'Стать учеником'
          href  : '/be_pupil'
          list  : {
            'Тест' : '#'
            'Тест1' : '#'
            'Тест2' : '#'
          }
        }
        module 'tutor/header/list_button' : {
          title : 'Репетиторам'
          href  : '/main_tutor'
          list  : {
            'как это работает1' : '#'
            'как это работает2' : '#'
            'как это работает3' : '#'
          }
        }
        module 'tutor/header/button' : {
          title : 'О нас'
          href  : '/about_us'
        }
      ]
    filter_top  : @exports()
    info_panel  : @exports()
    content     : @exports()
