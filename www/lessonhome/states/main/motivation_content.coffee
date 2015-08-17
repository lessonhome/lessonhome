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
          subject: 'Начальная школа'
          full_name: 'Прохненко Н.В.'
          price: 'от 1000 руб.за час'
          about_text: 'Подготовка к школе включает развивающие занятия, обучение чтению, счёту, подготовку руки к письму'
        @module '$/tutor_block' :
          img  :
            src : @F('main/best_2.jpg')
            w   : 112
            h   : 112
          subject: 'Английский язык'
          full_name: 'Боронкинова Н.Т.'
          price: 'от 1500 руб.за час'
          about_text: 'Обучаю разговорному английскому языку с 2004 на курсах, готовлю к международным экзаменам IELTS, TOEFL, ЕГЭ, ОГЭ'
        @module '$/tutor_block' :
          img  :
            src : @F('main/best_3.jpg')
            w   : 112
            h   : 112
          subject: 'Английский язык'
          full_name: 'Озерова И.И.'
          price: 'от 1000 руб.за час'
          about_text: 'Мой опыт и моя квалификация позволяет мне с уверенностью говорить, что я смогу быть другом и наставником детям.'
        @module '$/tutor_block' :
          img  :
            src : @F('main/best_4.jpg')
            w   : 112
            h   : 112
          subject: 'Французский язык'
          full_name: 'Магомедова Л.С.'
          price: 'от 1000 руб.за час'
          about_text: 'Изучала язык в школе, в институте, в Нормандском университете во Франции, преподавала в школе, на курсах, в институте.'
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