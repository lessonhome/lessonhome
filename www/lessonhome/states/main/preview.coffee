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
        state './preview/choose_tutor' :
          src     : '#'
          filling : '100'

        state './preview/choose_tutor' :
          src     : '#'
          filling : '50'
      ]

#      tutors           :  module '$/tutors'


