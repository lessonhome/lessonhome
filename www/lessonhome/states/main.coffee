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
    filter_top  : @exports()
    info_panel  : @exports()
    content     : @exports()
    footer : module 'footer' :
      logo : module 'tutor/header/logo'
      callback_popup : module 'callback_popup' :
        selector : 'footer'
        name        : module 'tutor/forms/input'  :
          text : 'Имя'
        placeholder : 'Ваше имя'
        tel_number  : module 'tutor/forms/input'  :
          text : 'Телефон'
        placeholder : 'Телефон'
        comments  : module 'tutor/forms/textarea' :
          placeholder : 'Комментарий'
        pupil       : module 'tutor/header/button_toggle' :
          text   : 'Я ученик'
          selector      : 'call_back_pupil inactive'
        tutor       : module 'tutor/header/button_toggle' :
          text  : 'Я репетитор'
          selector      : 'call_back_tutor inactive'
        order_call  : module 'tutor/button' :
          text  : 'Заказать звонок'
          selector      : 'call_back'
