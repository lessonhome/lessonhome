class @main extends @template '../main'
  tree : =>
    popup       : @exports()
    filter_top  : @exports()
    info_panel  : @exports()
    tag         : @exports()
    content     : @module '$' :
      reps : [
        @module '$/tutor_block' :
          subject: 'Английский язык'
          name: 'Иванова А.О.'
          price: 'от 500 руб.за час'
          about_text: 'Очень люблю и ценю свою работу, люблю преподавать материал порциооно, чтобы было легче'
        @module '$/tutor_block' :
          subject: 'Английский язык'
          name: 'Иванова А.О.'
          price: 'от 500 руб.за час'
          about_text: 'Очень люблю и ценю свою работу, люблю преподавать материал порциооно, чтобы было легче'
        @module '$/tutor_block' :
          subject: 'Английский язык'
          name: 'Иванова А.О.'
          price: 'от 500 руб.за час'
          about_text: 'Очень люблю и ценю свою работу, люблю преподавать материал порциооно, чтобы было легче'
        @module '$/tutor_block' :
          subject: 'Английский язык'
          name: 'Иванова А.О.'
          price: 'от 500 руб.за час'
          about_text: 'Очень люблю и ценю свою работу, люблю преподавать материал порциооно, чтобы было легче'
      ]
      ways_block_start: @module 'link_button' :
        selector: 'ways_block_start'
        text: 'НАЧАТЬ ПОИСК'
        href: '#'
      motivation_block_start: @module 'link_button' :
        selector: 'main_page_motivation'
        text: 'НАЧАТЬ ПОИСК'
      issue_bid: @module 'link_button' :
        selector: 'main_page_motivation'
        text: 'НАЧАТЬ ПОИСК'
      callback: @module 'link_button' :
        selector: 'main_page_motivation'
        text: 'НАЧАТЬ ПОИСК'