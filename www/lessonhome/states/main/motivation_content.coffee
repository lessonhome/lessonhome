class @main extends @template '../main'
  tree : =>
    popup       : @exports()
    filter_top  : @exports()
    info_panel  : @exports()
    tag         : @exports()
    content     : @module '$' :
      reps : [
        @state 'main/preview/tutors_result' :
          image : {
              src: ''
              w: 1000
              h: 800
            }
          rating : 3.5
          reclame : true
          selector  : 'jump_visit_card'
        # вытянуть значение
        #filling           : 100 # вытянуть значение
          cost      : 1000 # вытянуть значение
          value :
            name :
              first   : 'Андрей'
              middle  : 'Юрьевич'
              last    : 'Чехов'
            price_per_hour : 913.123
            subjects :
              'математика' :
                price :
                  left : 900
            location :
              city : 'Москва'
          #tutor_name        : 'Чехов Андрей Юрьевич' # вытянуть значение
            with_verification : 'rgb(183, 210, 120)' # вытянуть значение
            tutor_subject     : 'Математика' # вытянуть значение
            status      : 'cтудент' # вытянуть значение
            experience         : 3 # вытянуть значение
            tutor_place       : 'МО Зеленоград' # вытянуть значение
            tutor_title       : 'Быстро устраню пробелы в школьной программе' # вытянуть значение
            about        : 'Коллектив выступает с несколькими программами. В танцевальной программе выступают 2 пары, исполняющие мексиканские танцы (харибе тапатио), возможен мастер-класс по латиноамериканским танцам' # вытянуть значение
            tutor_price       : 1500 # вытянуть значение
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
      callback: @module 'tutor/header/elem_back_call' :
        trigger : @module 'link_button' :
          selector: 'main_page_motivation'
          text: 'ОБРАТНЫЙ ЗВОНОК'
          active: true
          href: '#'
        content : @state 'main/call_back_popup'