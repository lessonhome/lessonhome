class @main extends template '../main'
  tree : =>
    filter_top : @exports()

    info_panel  : state './info_panel'  :
      subject           : 'Предметы +'
      tutor             : 'Преподователь +'
      place             : 'Место'
      price             : 'Цена'
      selector          : 'second_step'

    content : module '$' :
      advanced_filter  : state './advanced_filter'
      sort             :  module '$/sort'

      choose_tutors : [
        state './preview/all_rating_photo' :
          src     : '#'
          filling : '100'
          selector  : 'padding_1px_small'
          close   : true

        state './preview/all_rating_photo' :
          src     : '#'
          filling : '50'
          selector  : 'padding_1px_small'
          close   : true
      ]

      tutors_result : [
        state './preview/tutors_result' :
          src               : '#'
          filling           : '100'
          count_review      : '255 отзывов'
          tutor_name        : 'Чехов Андрей Юрьевич'
          with_verification : 'rgb(183, 210, 120)'
          tutor_subject     : 'Математика'
          tutor_status      : 'cтудент'
          tutor_exp         : 'опыт 3 года'
          tutor_place       : 'МО Зеленоград'
          tutor_title       : 'Быстро устраню пробелы в школьной программе'
          tutor_text        : 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut laLorem ipsum dolor sit amet, consectetur adipisicing elit'
          tutor_price       : '1500'
      ]



