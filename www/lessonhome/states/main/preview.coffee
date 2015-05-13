class @main extends template '../main'
  forms : [{tutors:['tutor']}]
  tree : =>
    filter_top  : @exports()
    tag         : @exports()
    info_panel  : state './info_panel'  :
      subject   : 'Предметы +'
      tutor     : 'Преподаватель +'
      place     : 'Место'
      price     : 'Цена'
      selector  : 'second_step'

    content : module '$' :
      popup           : @exports()


      advanced_filter : state './advanced_filter' :
        val_list_course       : 'ЕГЭ' # вытянуть значение
        val_add_course        : ['ЕГЭ'] # вытянуть значение
        val_list_calendar     : 11 # вытянуть значение
        val_time_spend_lesson : # вытянуть значение
          min : 45
          max : 180
        val_time_spend_way    : # вытянуть значение
          min : 15
          max : 120
        val_choose_gender     : 11 # вытянуть значение
        val_with_reviews      : 11 # вытянуть значение
        val_with_verification : 11 # вытянуть значение
        


      sort            :  module '$/sort'
      choose_tutors_num : 2
      choose_tutors : [
        state './preview/all_rating_photo' :
          src       : '#'
          filling   : 100
          selector  : 'padding_1px_small'
          close     : true

        state './preview/all_rating_photo' :
          src       : '#'
          filling   : 50
          selector  : 'padding_1px_small'
          close     : true
      ]

      issue_bid_button : module 'tutor/button' :
        selector  : 'add_button_bid'
        text      : 'Оформить заявку'

      tutors : $form : tutors : 'tutor'
      tutors_result : [
          state './preview/tutors_result' :
            src               : '#'
            filling           : 100
            count_review      : 255
            tutor_name        : 'Чехов Андрей Юрьевич'
            with_verification : 'rgb(183, 210, 120)'
            tutor_subject     : 'Математика'
            tutor_status      : 'cтудент'
            tutor_exp         : 3
            tutor_place       : 'МО Зеленоград'
            tutor_title       : 'Быстро устраню пробелы в школьной программе'
            tutor_text        : 'Коллектив выступает с несколькими программами. В танцевальной программе выступают 2 пары, исполняющие мексиканские танцы (харибе тапатио), возможен мастер-класс по латиноамериканским танцам'
            tutor_price       : 1500

          state './preview/tutors_result' :
            src               : '#'
            filling           : 100
            count_review      : 255
            tutor_name        : 'Чехов Андрей Юрьевич'
            with_verification : 'rgb(183, 210, 120)'
            tutor_subject     : 'Математика'
            tutor_status      : 'cтудент'
            tutor_exp         : 3
            tutor_place       : 'МО Зеленоград'
            tutor_title       : 'Быстро устраню пробелы в школьной программе'
            tutor_text        : 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut laLorem ipsum dolor sit amet, consectetur adipisicing elit'
            tutor_price       : 1500

          state './preview/tutors_result' :
            src               : '#'
            filling           : 100
            count_review      : 255
            tutor_name        : 'Чехов Андрей Юрьевич'
            with_verification : 'rgb(183, 210, 120)'
            tutor_subject     : 'Математика'
            tutor_status      : 'cтудент'
            tutor_exp         : 3
            tutor_place       : 'МО Зеленоград'
            tutor_title       : 'Быстро устраню пробелы в школьной программе'
            tutor_text        : 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut laLorem ipsum dolor sit amet, consectetur adipisicing elit'
            tutor_price       : 1500

          state './preview/tutors_result' :
            src               : '#'
            filling           : 100
            count_review      : 255
            tutor_name        : 'Чехов Андрей Юрьевич'
            with_verification : 'rgb(183, 210, 120)'
            tutor_subject     : 'Математика'
            tutor_status      : 'cтудент'
            tutor_exp         : 3
            tutor_place       : 'МО Зеленоград'
            tutor_title       : 'Быстро устраню пробелы в школьной программе'
            tutor_text        : 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut laLorem ipsum dolor sit amet, consectetur adipisicing elit'
            tutor_price       : 1500

          state './preview/tutors_result' :
            src               : '#'
            filling           : 100
            count_review      : 255
            tutor_name        : 'Чехов Андрей Юрьевич'
            with_verification : 'rgb(183, 210, 120)'
            tutor_subject     : 'Математика'
            tutor_status      : 'cтудент'
            tutor_exp         : 3
            tutor_place       : 'МО Зеленоград'
            tutor_title       : 'Быстро устраню пробелы в школьной программе'
            tutor_text        : 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut laLorem ipsum dolor sit amet, consectetur adipisicing elit'
            tutor_price       : 1500
        ]



