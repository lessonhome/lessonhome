class @main
  tree : -> module '$' :
    depend      : state 'lib'
    header      : state './tutor/header' :
      items : [
        module 'tutor/header/button' : {
          title : 'Поиск'
          href  : '/first_step'
          tag   : 'pupil:main_search'
        }
        module 'tutor/header/list_button' : {
          tag   : 'pupil:fast_bid'
          title : 'Стать учеником'
          href  : '/fast_bid/first_step'
          list  : {
            'Как это работает'  : '#'
            'Оформить заявку'   : '/fast_bid/first_step'
            'Пригласить друга'  : '/invite_student'
            'Помощь'            : '#'
          }
        }
        module 'tutor/header/list_button' : {
          tag   : 'pupil:main_tutor'
          title : 'Репетиторам'
          href  : '/main_tutor'
          list  : {
            'Как это работает'  : '/main_tutor#how_it_works'
            'Стать репетитором' : '/main_tutor'
            'Пригласить друга'  : '/invite_teacher'
            'Помощь'            : '#'
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
    footer : module 'footer' :
      logo : module 'tutor/header/logo'
