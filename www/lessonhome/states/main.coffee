class @main
  tree : -> module '$' :
    lib      : state 'lib'
    header      : state './tutor/header' :
      items : [
        module 'tutor/header/button' : {
          title : 'Поиск'
          href  : '/'
          tag   : @exports()
        }
        module 'tutor/header/list_button' : {
          tag   : 'pupil:fast_bid'
          title : 'Стать учеником'
          href  : '/fast_bid/first_step'
          list  : [
            module '//item' :
              title : 'Как это работает'
              link : '/first_step#how-it-works'
              scrolltop : 'how-it-works'
            module '//item' :
              title : 'Оформить заявку'
              link : '/fast_bid/first_step'
            module '//item' :
              title : 'Пригласить друга'
              link : '/invite_student'
            module '//item' :
              title : 'Помощь'
              link : '#'
          ]
        }
        module 'tutor/header/list_button' : {
          tag   : 'pupil:main_tutor'
          title : 'Репетиторам'
          href  : '/main_tutor'
          list  : [
            module '//item' :
              title : 'Как это работает'
              link  : '/main_tutor#how-it-works'
              scrolltop : 'how-it-works'

            module '//item' :
              title : 'Стать репетитором'
              link  : '/main_tutor'

            module '//item' :
              title : 'Пригласить друга'
              link   : '/invite_teacher'

            module '//item' :
              title : 'Помощь'
              link : '#'
          ]
        }
        module 'tutor/header/button' : {
          title : 'О нас'
          href  : '/about_us'
        }
      ]
    popup       : @exports()              # show info about tutor in main page
    filter_top  : @exports()              # top filter in main page
    #info_panel  : @exports()              # info panel in main page
    content     : @exports()              # after info panel block in main page
    footer      : state 'footer'          # footer in main page
