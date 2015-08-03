class @main extends @template '../main'
  tree : =>
    popup       : @exports()
    filter_top  : @exports()
    info_panel  : @exports()
    tag         : @exports()
    content     : @module '$' :
      reps : [
        @module '$/tutor_block' :
          img  :
            src : @F('main/best_1.jpg')
            w   : 112
            h   : 112
          subject: 'Физика'
          full_name: 'Черепанов В.С.'
          price: 'от 750 руб.за час'
          about_text: 'Быстро подготовлю к любым экзаменам по физике. Индидуальный подход к ученику'
        @module '$/tutor_block' :
          img  :
            src : @F('main/best_2.jpg')
            w   : 112
            h   : 112
          subject: 'Русский язык'
          full_name: 'Сидельникова А.О.'
          price: 'от 600 руб.за час'
          about_text: 'Очень люблю и ценю свою работу, люблю преподавать материал порционно для облегчённого понимания'
        @module '$/tutor_block' :
          img  :
            src : @F('main/best_3.jpg')
            w   : 112
            h   : 112
          subject: 'Английский язык'
          full_name: 'Иванова С.К.'
          price: 'от 650 руб.за час'
          about_text: 'Английский язык - это просто! Быстро помогу освоить навыки говорения, чтения и беглой речи!'
        @module '$/tutor_block' :
          img  :
            src : @F('main/best_4.jpg')
            w   : 112
            h   : 112
          subject: 'История'
          full_name: 'Тихомиров В.В.'
          price: 'от 700 руб.за час'
          about_text: 'Преподаю историю в вузе. Готов подготовить к экзаменам и расширить общие знания по предмету'
      ]
      ways_block_start: @module 'link_button' :
        selector: 'ways_block_start'
        text: 'НАЧАТЬ ПОИСК'
        active : true
        href: '/second_step'
      motivation_block_start: @module 'link_button' :
        selector: 'main_page_motivation'
        text: 'НАЧАТЬ ПОИСК'
        active : true
        href: '/second_step'
      issue_bid: @module 'link_button' :
        selector: 'main_page_motivation'
        text: 'ОФОРМИТЬ ЗАЯВКУ'
        active: true
        href: '/fast_bid/first_step'
      callback: @module 'link_button' :
        selector: 'main_page_motivation'
        text: 'ОБРАТНЫЙ ЗВОНОК'
        active: true
        href: '/main_callback'