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
            src : @F('main/best_rep1.jpg')
            w   : 112
            h   : 112
          subject: 'Английский язык'
          full_name: 'Иванова А.О.'
          price: 'от 500 руб.за час'
          about_text: 'Очень люблю и ценю свою работу, люблю преподавать материал порциооно, чтобы было легче'
        @module '$/tutor_block' :
          img  :
            src : @F('main/best_rep2.jpg')
            w   : 112
            h   : 112
          subject: 'Английский язык'
          full_name: 'Иванова А.О.'
          price: 'от 500 руб.за час'
          about_text: 'Очень люблю и ценю свою работу, люблю преподавать материал порциооно, чтобы было легче'
        @module '$/tutor_block' :
          img  :
            src : @F('main/best_rep3.jpg')
            w   : 112
            h   : 112
          subject: 'Английский язык'
          full_name: 'Иванова А.О.'
          price: 'от 500 руб.за час'
          about_text: 'Очень люблю и ценю свою работу, люблю преподавать материал порциооно, чтобы было легче'
        @module '$/tutor_block' :
          img  :
            src : @F('main/best_rep4.jpg')
            w   : 112
            h   : 112
          subject: 'Английский язык'
          full_name: 'Иванова А.О.'
          price: 'от 500 руб.за час'
          about_text: 'Очень люблю и ценю свою работу, люблю преподавать материал порциооно, чтобы было легче'
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