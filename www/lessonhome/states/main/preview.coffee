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

#      tutors           :  module '$/tutors'


