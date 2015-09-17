class @main extends @template '../main'
  forms : [{tutors:['tutor']}]
  tree : =>
    filter_top  : @exports()
    tag         : @exports()
    ###
    info_panel  : @state './info_panel'  :
      subject   : 'Предметы +'
      tutor     : 'Преподаватель +'
      place     : 'Место'
      price     : 'Цена'
      selector  : 'second_step'

    ###

    content : @module '$' :
      popup           : @exports()
      advanced_filter : @state './advanced_filter' :
        val_list_course       : '' # вытянуть значение
        val_list_calendar     : 11 # вытянуть значение
        val_time_spend_lesson : # вытянуть значение
          min : 45
          max : 180
        val_time_spend_way    : # вытянуть значение
          min : 15
          max : 120
        val_choose_gender     : false # вытянуть значение
        val_with_reviews      : 11 # вытянуть значение
        val_with_verification : 11 # вытянуть значение

      sort            :  @module '$/sort' :
        value :
          sort : $urlform : mainFilter : 'sort'
          show : $urlform : mainFilter : 'showBy'
      choose_tutors_num : 2
      choose_tutors : []
      #  @state './preview/all_rating_photo' :
      #    src       : '#'
      #    #filling   : 100
      #    selector  : 'padding_1px_small'
      #    close     : true
      #
      #  @state './preview/all_rating_photo' :
      #    src       : '#'
      #    #filling   : 50
      #    selector  : 'padding_1px_small'
      #    close     : true


      tutors : $form : tutors : 'tutor'
      tutor_test :
        @state './preview/tutors_result' :
          image : {
            src: ''
            w: 1000
            h: 800
          }
          rating : 3.5
          stars       : true
          selector  : 'main_visit_card'
        # вытянуть значение
          #filling           : 100 # вытянуть значение
          count_review      : 0 # вытянуть значение
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
            status            : 'cтудент' # вытянуть значение
            experience        : 3 # вытянуть значение
            tutor_place       : 'МО Зеленоград' # вытянуть значение
            tutor_title       : 'Быстро устраню пробелы в школьной программе' # вытянуть значение
            about             : 'Коллектив выступает с несколькими программами. В танцевальной программе выступают 2 пары, исполняющие мексиканские танцы (харибе тапатио), возможен мастер-класс по латиноамериканским танцам' # вытянуть значение
            tutor_price       : 1500 # вытянуть значение



